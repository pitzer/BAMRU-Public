class TkCanvas
  def coords(evt)
    return [canvasx(evt.x), canvasy(evt.y)]
  end

  # TkCanvas redefines raise() (and lower()) to operate on tags.
  # But our layout classes (VBox and Scrolled) require a proper raise(),
  # so we restore its behavior.
  # @todo: find out the "correct" way to do it.
  def raise
    super
  end
end

module TkImageMap

  # A widget to show an image together with an HTML imagemap.
  class ImageMap < TkCanvas

    def select_command &block
      @select_command = block
    end

    def double_select_command &block
      @double_select_command = block
    end

    # Returns all the URLs.
    def urls
      @hotspots.map { |h| h[:url] }
    end

    # I'm not yet sure I want ImageMap to be a TkCanvas directly (an
    # alternative would be for it to control an external canvas). So,
    # for future compatibility, I access the canvas through canvas()
    # instead of assuming it's 'self'.
    def canvas
      self
    end

    def initialize(parent, *rest)
      super
      @hover_region = nil
      @active_region = nil
      @hotspots = []
      @image_widget = nil
      @select_command = proc {}
      @double_select_command = proc {}

      # Attach scrolling to middle button.
      canvas.bind('2', proc { |x,y| canvas.scan_mark(x,y) }, '%x %y')
      canvas.bind('B2-Motion', proc { |x,y| canvas.scan_dragto x, y }, '%x %y')

      canvas.pack :expand => true, :fill => 'both'

      ['Motion','Control-Motion'].each { |sequence|
        canvas.bind sequence do |evt|
          x, y = canvas.coords(evt)
          spot = canvas.find('overlapping', x, y, x + 1, y + 1).first
          if spot and spot.cget('tags').include? 'hotspot'
            new_hover_region = spot.hotspot_region
          else
            new_hover_region = nil
          end
          if new_hover_region != @hover_region
            @hover_region[:hover_spot].configure(:state => 'hidden') if @hover_region
            @hover_region = new_hover_region
            @hover_region[:hover_spot].configure(:state => 'disabled') if @hover_region # like 'visible'
            if sequence['Control']
              self.active_region = @hover_region
            end
          end
        end
      }
      canvas.bind 'Button-1' do |evt|
        x, y = canvas.coords(evt)
        spot = canvas.find('overlapping', x, y, x+1, y+1).first
        if spot and spot.cget('tags').include? 'hotspot'
          self.active_region = spot.hotspot_region
        else
          self.active_region = nil
        end
      end
      canvas.bind 'Double-Button-1' do
        @double_select_command.call(active_url) if @active_region
      end
      # Middle button: vertical scrolling.
      canvas.bind 'Button-4' do
        canvas.yview_scroll(-1, 'units')
      end
      canvas.bind 'Button-5' do
        canvas.yview_scroll(1, 'units')
      end
      # Middle button: horizontal scrolling.
      canvas.bind 'Shift-Button-4' do
        canvas.xview_scroll(-1, 'units')
      end
      canvas.bind 'Shift-Button-5' do
        canvas.xview_scroll(1, 'units')
      end
    end

    def active_region=(region)
      if region != @active_region
        @active_region[:active_spot].configure(:state => 'hidden') if @active_region
        @active_region = region
        @active_region[:active_spot].configure(:state => 'disabled') if @active_region # like 'visible'
        @select_command.call(active_url)
      end
    end

    def active_url
      @active_region ? @active_region[:url] : nil
    end

    def active_url=(newurl)
      catch :found do
        @hotspots.each { |region|
          if region[:url] == newurl
            self.active_region = region
            throw :found
          end
        }
        # It was not found:
        self.active_region = nil
      end
    end

    def image=(pathname)
      @image = TkPhotoImage.new :file => pathname
      canvas.configure :scrollregion => [0, 0, @image.width, @image.height]
    end

    # You must call this after image=()
    def image_map=(pathname)
      # Delete the previous spot widgets and the image widget.
      canvas.find('all').each {|w| w.destroy }
      canvas.xview_moveto(0)
      canvas.yview_moveto(0)

      @hotspots = Utils.parse_imap(pathname)

      #
      # Create the back spots.
      #
      @hotspots.each do |region|
        args = [canvas, *(region[:args])]
        opts = {
          :fill => 'red',
          :tags => ['hotspot']
        }
        back_spot = region[:class].new *(args + [opts])
        # The following won't work, so we have to use define_method instead.
        #def back_spot.hotspot_region
        #   region
        #end
        meta = class << back_spot; self; end
        meta.send :define_method, :hotspot_region do
          region
        end
      end

      @image_widget = TkcImage.new(canvas,0,0, :image => @image, :anchor=> 'nw')

      #
      # Create the hover spots.
      #
      @hotspots.each do |region|
        args = [canvas, *(region[:args])]
        opts = {
          :dash => '. ',
          :width => 5,
          :fill => nil,
          :outline => 'black',
          :state => 'hidden'
        }
        region[:hover_spot] = region[:class].new *(args + [opts])
        opts = {
          :width => 5,
          :fill => nil,
          :outline => 'black',
          :state => 'hidden'
        }
        region[:active_spot] = region[:class].new *(args + [opts])
      end
    end
  end # class ImageMap

  module Utils

    # DOT outputs oval elements as polygons with many many sides. Since Tk doesn't
    # draw them well, we convert such polygons to ovals.
    def self.to_oval(coords)
      require 'enumerator'
      #points = coords.each_slice(2).to_a # Doesn't work for older 1.8's.
      points = coords.enum_for(:each_slice, 2).to_a
      if points.size < 10
        # If there are few sides, we assume it's a real polygon.
        return nil
      end
      # Alas, Ruby 1.8.6 doesn't have #minmax
      xs = points.map {|p| p[0]}
      ys = points.map {|p| p[1]}
      x_min, x_max = xs.min, xs.max
      y_min, y_max = ys.min, ys.max
      # @todo: try to figure out if the points trace a circle?
      #center_x = x_min + (x_max - x_min) / 2.0
      #center_y = y_min + (y_max - y_min) / 2.0
      #points.each do |x,y|
      #end
      return [x_min, y_min, x_max, y_max]
    end

    # Parses an HTML image map.
    def self.parse_imap(filepath)
      hotspots = []
      require 'rexml/document'
      doc = REXML::Document.new(File.open(filepath))
      doc.root.elements.each do |elt|
        if elt.is_a? REXML::Element and elt.name == 'area'
          attrs  = elt.attributes
          url    = attrs['href']
          coords = attrs['coords'].split(/,|\s+/).map{|c|c.to_i}  # @todo: A circle's radius can be a percent.
          case attrs['shape']
          when 'poly';
            if args = to_oval(coords)
              hotspots << {
                :args => args,
                :class => TkcOval,
                :url => url,
              }
            else
              hotspots << {
                :args => coords,
                :class => TkcPolygon,
                :url => url,
              }
            end
          when 'rect';
            hotspots << {
              :args => coords,
              :class => TkcRectangle,
              :url => url,
            }
          when 'circle';
            cx, cy, radius = coords
            hotspots << {
              :args => [cx - radius, cy - radius, cx + radius, cy + radius],
              :class => TkcOval,
              :url => url,
            }
          else raise "I don't support shape '#{attrs['shape']}'"
          end
        end
      end
      return hotspots
    end
  end # module Utils

end # module TkImageMap

if $0 == __FILE__    # A little demonstration.

  class App  # :nodoc:
    def initialize
      @root = TkRoot.new
      im = TkImageMap::ImageMap.new(@root)
      im.pack :expand => true, :fill => 'both'
      im.image = 'a.gif'
      im.image_map = 'a.map'
      im.select_command { |url|
        if url
          puts 'clicked: ' + url
        else
          puts 'cleared'
        end
      }
      im.double_select_command { |url|
        puts 'going to ' + url
      }
      btn = TkButton.new @root
      btn.pack
      btn.command {
        p 'button clicked'
        im.active_url = 'http://server/obj/o_1224289036'
      }
    end
  end

  app = App.new
  Tk.mainloop

end
