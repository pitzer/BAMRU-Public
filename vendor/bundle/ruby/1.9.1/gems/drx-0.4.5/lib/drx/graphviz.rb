# Adds Graphviz diagramming capability to ObjInfo

module Drx

  class ObjInfo

    # Notes:
    # - Windows' CMD.EXE too supports "2>&1"
    # - We're generating GIF, not PNG, because that's a format Tk
    #   supports out of the box.
    # - Each {extension} token is replaced by the filepath with that extension.
    GRAPHVIZ_COMMAND = 'dot "{dot}" -Tgif -o "{gif}" -Tcmapx -o "{map}" 2>&1'

    @@sizes = {
      '100%' => "
        node[fontsize=10]
      ",
      '90%' => "
        node[fontsize=10]
        ranksep=0.4
        edge[arrowsize=0.8]
      ",
      '80%' => "
        node[fontsize=10]
        ranksep=0.3
        nodesep=0.2
        node[height=0.4]
        edge[arrowsize=0.6]
      ",
      '60%' => "
        node[fontsize=8]
        ranksep=0.18
        nodesep=0.2
        node[height=0]
        edge[arrowsize=0.5]
      "
    }

    # Create an ID for the DOT node representing this object.
    def dot_id
       ('o' + address.to_s).sub('-', '_')
       # Tip: when examining the DOT output you may wish to
       # uncomment the following line. It will show you which
       # ruby object the DOT node represents.
       #('o' + address.to_s).sub('-', '_') + " /* #{repr} */ "
    end

    # Creates a pseudo URL for the HTML imagemap.
    def dot_url
      "http://ruby/object/#{dot_id}"
    end

    # Quotes a string to be used in DOT source.
    def dot_quote(s)
      '"' + s.gsub('\\') { '\\\\' }.gsub('"', '\\"').gsub("\n", '\\n') + '"'
    end

    # Returns the DOT style for the node.
    def dot_style__default
      if singleton?
        # A singleton class
        "shape=oval,color=skyblue1,style=filled"
      elsif t_class?
        # A class
        "shape=oval,color=lightblue1,style=filled"
      elsif t_iclass? or t_module?
        # A module
        if repr['#']
          # Paint anonymous modules only lightly.
          "shape=box,style=filled,color=\"#D9FFF2\",fontcolor=gray60"
        else
          "shape=box,style=filled,color=aquamarine"
        end
      else
        # Else: a "normal" object, or an immediate.
        "shape=house,color=wheat1,style=filled"
      end
    end

    # Returns the DOT style for the node.
    def dot_style__crazy
      craze = "distortion=#{2*rand-1},skew=#{2*rand-1},orientation=#{360*rand}"
      crazy_oval = "shape=polygon,sides=25," + craze
      crazy_rect = "shape=polygon,sides=#{4+rand(3)}," + craze
      if singleton?
        # A singleton class
        "#{crazy_oval},color=palevioletred3,style=filled,fontcolor=white,peripheries=3"
      elsif t_class?
        # A class
        "#{crazy_oval},color=palevioletred1,style=filled"
      elsif t_iclass? or t_module?
        # A module
        "#{crazy_rect},color=peachpuff1,style=filled"
      else
        # Else: a "normal" object, or an immediate.
        "shape=house,color=pink,style=filled"
      end
    end

    # Returns the DOT label for the node.
    #
    # The representation may be quite big, so we trim it.
    def dot_label(max = 20)
      if class_like?
        # Let's be more lenient when trimming a class/module name.
        # We want to show The::Last::Component and possibly a singleton's
        # trailing 'S.
        max = 60 if max < 60
      end
      r = repr
      if r.length > max
        r[0, max] + ' ...'
      else
        r
      end
    end

    # Builds the DOT source for the diagram. if you're only interested
    # in the output image, use generate_diagram() instead.
    def dot_source(opts = {}, &block) # :yield:
      opts = opts.dup
      opts[:base] = self
      @@seen = {}

      out = 'digraph {' "\n"
      out << @@sizes[opts[:size] || '100%']
      out << dot_fragment(opts, &block)
      out << '}' "\n"
      out
    end

    def dot_fragment(opts = {}, ancestors = [], &block) # :yield:
      out = ''
      # Note: since 'obj' may be a T_ICLASS, it doesn't respond to many methods,
      # including is_a?. So when we're querying things we're using Drx calls
      # instead.

      seen = @@seen[address]
      @@seen[address] = true

      if not seen
        dot_style = method('dot_style__' + (opts[:style] || 'default')).call
        out << "#{dot_id} [#{dot_style}, label=#{dot_quote dot_label}, URL=#{dot_quote dot_url}];" "\n"
      end

      yield self if block_given?

      return '' if seen

      if class_like?
        if spr = self.super and display_super?(spr, ancestors)
          out << spr.dot_fragment(opts, ancestors + [self], &block)
          if insignificant_super_arrow?(opts, ancestors)
            # We don't want these relatively insignificant lines to clutter the display,
            # so we paint them lightly and tell DOT they aren't to affect the layout (width=0).
            out << "#{dot_id} -> #{spr.dot_id} [color=gray85, weight=0];" "\n"
          else
            out << "#{dot_id} -> #{spr.dot_id};" "\n"
          end
        end
      end

      kls = effective_klass
      if display_klass?(kls)
        out << kls.dot_fragment(opts, &block)
        # Recall that in Ruby there are two main inheritance groups: the class
        # inheritance and the singleton inheritance.
        #
        # When an ICLASS has a singleton, we want this singleton to appear close
        # to the ICLASS, because we want to keep the two groups visually distinct.
        # We do this by setting the arrow's weight to 1.0.
        #
        # (To see the effect of this, set the weight unconditionally to '0' and
        # see the graph for DataMapper.)
        weight = t_iclass? ? 1 : 0

        # However, here's a special case. DOT seems to have a bug: it sometimes
        # doesn't draw the arrows going out of Class and Module (to their
        # singletons). Making their weight 1 makes DOT draw them.
        weight = 1 if self == _Class or self == _Module

        out << "#{dot_id} -> #{kls.dot_id} [style=dotted, weight=#{weight}];" "\n"
        out << "{ rank=same; #{dot_id}; #{kls.dot_id}; }" "\n"
      end

      out
    end

    # Whether the 'super' arrow is infignificant and must not affect the DOT
    # layout
    #
    # A Ruby object graph is cyclic. We don't want to feed DOT a cyclic graph
    # because it will ruin our nice "rectangular" layout. The purpose of the
    # following method is to break the cycle. Normally we break the cycle at
    # Module (and its singleton). When the user is examining a module, we
    # instead break the cycle at Class (and its singleton).
    def insignificant_super_arrow?(opts, my_ancestors)
      if opts[:base].t_module?
        self == _ClassS or
          (self.super == _Module and (my_ancestors + [self]).include? _Class)
      else
        self == _ModuleS or
          (self.super == _Object and (my_ancestors + [self]).include? _Module)
      end
    end

    # Whether to display the klass.
    def display_klass?(kls)
      if t_iclass?
        # We're interested in an ICLASS's klass only if it isn't Module.
        #
        # Usually this means that the ICLASS has a singleton (see "Singletons
        # of included modules" in display_super?()). We want to see this
        # singleton.

        # Unfortunately, here is a special treatment for the 'arguments' gem,
        # which our GUI uses. That gem includes the 'Arguments' module in both
        # Class and Module (this is redundant!) and having the singleton twice
        # in our graph may break its nice rectangular structure. So we don't
        # show its singleton.
        if defined? ::Arguments
           return false if ::Arguments == klass.the_object
        end

        return kls != _Module
      else
        # Displaying a singleton's klass is confusing and usually unneeded.
        return !singleton?
      end
    end

    # Whether to display the super.
    def display_super?(spr, my_ancestors)
      if spr == _Module
        # Many objects have Module as their super (e.g., singletones
        # of included modules, or modules included in them). To prevent
        # clutter we print the arrow to Module only if it comes from
        # Class (or a module included in it).
        return (my_ancestors + [self]).include?(_Class)
        #
        # A somewhat irrelevant note (I don't have a better place to put it):
        #
        # "Singletons of included modules" often exist solely for their
        # #included method. For example, DataMapper#Resource has
        # such a singleton.
      end
      return true
    end

    # Like klass(), but without surprises.
    #
    # Since the klass of an ICLASS is the module itself, we need to
    # invoke klass() twice.
    def effective_klass
      if t_iclass?
        klass.klass
      else
        klass
      end
    end

    # Shortcuts for some specific objects. An "S" suffix
    # denotes a singleton.
    protected
    def _Module; ObjInfo.new(Module); end
    def _ModuleS; ObjInfo.new(Module).klass; end
    def _Object; ObjInfo.new(Object); end
    def _ObjectS; ObjInfo.new(Object).klass; end
    def _Class; ObjInfo.new(Class); end
    def _ClassS; ObjInfo.new(Class).klass; end
    public

    # Generates a diagram of the inheritance hierarchy. It accepts a hash
    # pointing to filepaths to write the result to. A Tempfiles hash
    # can be used instead.
    #
    #   the_object = "some object"
    #   Tempfiles.new do |files|
    #     ObjInfo.new(the_object).generate_diagram
    #     system('xview ' + files['gif'])
    #   end
    #
    def generate_diagram(files, opts = {}, &block)
      source = self.dot_source(opts, &block)
      File.open(files['dot'], 'w') { |f| f.write(source) }
      # Replace {extension} tokens with their corresponding filepaths:
      command = GRAPHVIZ_COMMAND.gsub(/\{([a-z]+)\}/) { files[$1] }
      message = Kernel.`(command)  # `
      if $? != 0
        error = <<-EOS % [command, message]
ERROR: Failed to run the 'dot' command. Make sure you have the GraphViz
package installed and that its bin folder appears in your PATH.

The command I tried to execute is this:

%s

And the response I got is this:

%s
        EOS
        raise error
      end
    end

  end
end
