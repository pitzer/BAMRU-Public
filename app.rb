require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'ruby-debug'

class BamruApp < Sinatra::Base

  configure do
    BASE_DIR  = File.dirname(File.expand_path(__FILE__))
    QUOTES    = YAML.load_file(BASE_DIR + "/quotes.yaml")
    RIGHT_NAV = YAML.load_file(BASE_DIR + "/right_nav.yaml")
    GUEST_POLICY = File.read(BASE_DIR + "/guest_policy.html")
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

    def blog_url
      "http://bamru.blogspot.com"
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
  
  get '/calendar' do
    @title     = "BAMRU Calendar"
    @hdr_img   = "images/mtn.jpg"
    @right_nav = right_nav(:calendar)
    @right_txt = GUEST_POLICY
    @left_txt  = quote
    erb :calendar
  end

  get '/bamruinfo' do
    @title     = "Information about BAMRU"
    @hdr_img   = "images/approach.jpg"
    @right_nav = right_nav(:bamruinfo)
    @left_txt  = quote
    erb :bamruinfo
  end

  get '/join' do
    @title     = "Joining BAMRU"
    @hdr_img   = "images/helo.jpg"
    @right_nav = right_nav(:join)
    @right_txt = quote
    erb :join
  end

  get '/sgallery' do
    @title     = "BAMRU Photo Gallery"
    @hdr_img   = "images/hills.jpg"
    @right_nav = right_nav(:sgallery)
    erb :sgallery
  end

  get '/meeting_locations' do
    @title     = "BAMRU Meeting Location"
    @hdr_img   = "images/mtn_2.jpg"
    @right_nav = right_nav(:meeting_locations)
    @right_txt = quote
    erb :meeting_locations
  end

  get '/sarlinks' do
    @title     = "Links to SAR-related sites"
    @hdr_img   = "images/glacier.jpg"
    @right_nav = right_nav(:sarlinks)
    @right_txt = quote
    erb :sarlinks
  end

  get '/donate' do
    @title     = "Donate to BAMRU"
    @hdr_img   = "images/glacier.jpg"
    @right_nav = right_nav(:donate)
    @right_txt = quote
    erb :donate
  end

  get '/contact' do
    @title     = "BAMRU Contacts"
    @hdr_img   = "images/HawthornLZ.jpg"
    @right_nav = right_nav(:contact)
    @right_txt = quote
    erb :contact
  end

end
