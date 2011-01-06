base_dir = File.dirname(File.expand_path(__FILE__))
require 'rubygems'
# require 'bundler/setup'
require 'yaml'
require 'ruby-debug'
require 'rack-flash'
require base_dir + '/config/environment'

class BamruApp < Sinatra::Base

  configure do
    enable :sessions
    use Rack::Flash
    set :erb, :trim => '-'
    BASE_DIR  = File.dirname(File.expand_path(__FILE__))
    QUOTES    = YAML.load_file(BASE_DIR + "/data/quotes.yaml")
    RIGHT_NAV = YAML.load_file(BASE_DIR + "/data/right_nav.yaml")
    GUEST_POLICY   = File.read(BASE_DIR + "/data/guest_policy.html")
  end

  helpers do
    def current_page
      request.path_info
    end

    def quote
      index = rand(QUOTES.length)
      <<-HTML
        <br/><p/>
        <img src="assets/axe.gif" border="0">
        <div class='quote_box'>
          <div class='quote'>"#{QUOTES[index][:text]}"</div>
          <div class='caps'>- #{QUOTES[index][:auth]}</div>
        </div>
      HTML
    end

    def set_flash_notice(msg)
      flash[:notice] = msg
    end

    def get_flash_notice
      var = flash[:notice]
#      flash.delete(:notice) unless flash[:notice].nil?
      var
    end

    def set_flash_error(msg)
      flash[:error] = msg
    end

    def get_flash_error
      var = flash[:error]
#      flash.delete(:error) unless flash[:error].nil?
      var
    end

    def event_edit_link(eventid)
      "<a href='/admin_edit/#{eventid}'>edit</a>"
    end

    def event_delete_link(eventid)
      "<a href='/admin_delete/#{eventid}'>delete</a>"
    end
    
    def event_table(events)
      output = "<table class='basic'>"
      events.each do |m|
        output << "<tr><td>#{m.title} / #{m.location}</td><td>#{m.start}</td><td>#{m.leaders}</td><td class='ac'>#{event_edit_link(m.id)} | #{event_delete_link(m.id)}</td></tr>"
      end
      output << "</table>"
      output
    end

    def blog_url
      "http://bamru.blogspot.com"
    end

    def admin_link(target, label)
      link = "<a href='#{target}'>#{label}</a>"
      target == current_page ? label : link
    end

    def admin_nav
      opt1 = [
              ['/admin',     'Admin Home'],
              ['/admin_new', 'Create Event'],
              ['/admin_load_csv', 'Upload CSV']
             ]
      opt2 = [
              ['/calendar.test', 'calendar.html'],
              ['/calendar.ical', 'calendar.ical'],
              ['/calendar.csv', 'calendar.csv']
             ]
      r1 = opt1.map {|i| admin_link(i.first, i.last)}.join(' | ')
      r2 = opt2.map {|i| admin_link(i.first, i.last)}.join(' | ')
      "#{r1} || #{r2}<p/><hr>"
    end

    def right_link(target, label)
      "<a href='#{target}' class='nav3' onfocus='blur();'>#{label}</a><br/>"
    end
    
    def right_nav(page)
#      debugger
      RIGHT_NAV[page].reduce("") {|a, v| a << right_link(v.last, v.first)} unless RIGHT_NAV[page].nil?
    end

    def menu_link(target, label)
      cls = current_page == target ? "nav4" : "nav1"
      <<-HTML
      <a href='#{target}' class='#{cls}' onfocus='blur();'>#{label}</a><br/>
      HTML
    end

    def dot_hr
      '<img src="assets/dots.gif" width="134" height="10" border="0"><br>'
    end
  end

  get '/' do
    redirect "/index-2.html"
  end
  
  get '/calendar.test' do
    @title     = "BAMRU Calendar"
    @hdr_img   = "images/mtn.jpg"
    @right_nav = right_nav(:calendar)
    @right_txt = GUEST_POLICY
    @left_txt  = quote
    erb :calendar
  end

  get '/bamruinfo.test' do
    @title     = "Information about BAMRU"
    @hdr_img   = "images/approach.jpg"
    @right_nav = right_nav(:bamruinfo)
    @left_txt  = quote
    erb :bamruinfo
  end

  get '/join.test' do
    @title     = "Joining BAMRU"
    @hdr_img   = "images/helo.jpg"
    @right_nav = right_nav(:join)
    @right_txt = quote
    erb :join
  end

  get '/sgallery.test' do
    @title     = "BAMRU Photo Gallery"
    @hdr_img   = "images/hills.jpg"
    @right_nav = right_nav(:sgallery)
    erb :sgallery
  end

  get '/meeting_locations.test' do
    @title     = "BAMRU Meeting Location"
    @hdr_img   = "images/mtn_2.jpg"
    @right_nav = right_nav(:meeting_locations)
    @right_txt = quote
    erb :meeting_locations
  end

  get '/sarlinks.test' do
    @title     = "Links to SAR-related sites"
    @hdr_img   = "images/glacier.jpg"
    @right_nav = right_nav(:sarlinks)
    @right_txt = quote
    erb :sarlinks
  end

  get '/donate.test' do
    @title     = "Donate to BAMRU"
    @hdr_img   = "images/glacier.jpg"
    @right_nav = right_nav(:donate)
    @right_txt = quote
    erb :donate
  end

  get '/contact.test' do
    @title     = "BAMRU Contacts"
    @hdr_img   = "images/HawthornLZ.jpg"
    @right_nav = right_nav(:contact)
    @right_txt = quote
    erb :contact
  end

  get '/admin' do
    @meetings   = Event.where(:kind => "meeting").all
    @trainings  = Event.where(:kind => "training").all
    @events     = Event.where(:kind => "event").all
    @non_county = Event.where(:kind => "non_county").all
    erb :admin, :layout => :admin_layout
  end

  get '/admin_new' do
    erb :admin_new, :layout => :admin_layout
  end

  get '/admin_edit/:id' do
    @event = Event.find_by_id(params[:id])
    erb :admin_edit, :layout => :admin_layout
  end

  get '/admin_delete/:id' do
    event = Event.find_by_id(params[:id])
    set_flash_notice "Deleted #{event.title}"
    event.destroy
    redirect "/admin"
  end

  get '/calendar.ical' do
    response["Content-Type"] = "text/plain"
    @events = Event.all
    erb :admin_export_ical, :layout => false
  end

  get '/calendar.csv' do
    response["Content-Type"] = "text/plain"
    @events = Event.all
    erb :admin_export_csv, :layout => false
  end

  get '/admin_load_csv' do
    erb :admin_load_csv, :layout => :admin_layout
  end

  not_found do
    @right_nav = quote
    @hdr_img   = "images/mtn.jpg"
    erb :not_found
  end


end
