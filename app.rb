require 'rubygems'
require 'bundler/setup'
require 'yaml'
require 'ruby-debug'

class BamruApp < Sinatra::Base

  configure do
    BASE_DIR = File.dirname(File.expand_path(__FILE__))
    QUOTES   = YAML.load_file(BASE_DIR + "/quotes.yaml")
  end

  helpers do
    def current_page
      request.path_info
    end

    def quote
      idx = rand(QUOTES.length)
      <<-HTML
        <div class='quote_box'>
          <div class='quote'>"#{QUOTES[idx][:text]}"</div>
          <div class='caps'>- #{QUOTES[idx][:auth]}</div>
        </div>
      HTML
    end

    def blog_url
      "http://bamru.blogspot.com"
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
    @title    = "BAMRU Calendar"
    @hdr_img  = "images/mtn.jpg"
    @side_txt = "TBD"
    erb :calendar
  end

  get '/bamruinfo' do
    @title    = "Information about BAMRU"
    @hdr_img  = "images/approach.jpg"
    @side_txt = "TBD"
    erb :bamruinfo
  end

  get '/join' do
    @title    = "Joining BAMRU"
    @hdr_img  = "images/helo.jpg"
    @side_txt = "TBD"
    erb :join
  end

  get '/sgallery' do
    @title    = "BAMRU Photo Gallery"
    @hdr_img  = "images/hills.jpg"
    @side_txt = "TBD"
    erb :sgallery
  end

  get '/meeting_locations' do
    @title    = "BAMRU Meeting Location"
    @hdr_img  = "images/mtn_2.jpg"
    @side_txt = "TBD"
    erb :meeting_locations
  end

  get '/sarlinks' do
    @title    = "Links to SAR-related sites"
    @hdr_img  = "images/glacier.jpg"
    @side_txt = "SEARCH & RESCUE LINKS"
    erb :sarlinks
  end

  get '/donate' do
    @title    = "Donate to BAMRU"
    @hdr_img  = "images/glacier.jpg"
    @side_txt = @title
    erb :donate
  end

  get '/contact' do
    @title    = "BAMRU Contacts"
    @hdr_img  = "images/HawthornLZ.jpg"
    @side_txt = "CONTACTS"
    erb :contact
  end

end
