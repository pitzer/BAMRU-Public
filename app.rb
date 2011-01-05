class BamruApp < Sinatra::Base

  helpers do
    def current_page
      request.path_info
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
    redirect "/index.html"
  end

  get '/contact' do
    @hdr_img = "images/HawthornLZ.jpg"
    @side_title = "CONTACTS"
    erb :contact
  end

  get '/donate' do
    @hdr_img = "images/glacier.jpg"
    @side_title = "Donate to BAMRU"
    erb :donate
  end

  get '/sarlinks' do
    @hdr_img = "images/glacier.jpg"
    @side_title = "SEARCH & RESCUE LINKS"
    erb :sarlinks
  end

  get '/meeting_locations' do
    @hdr_img = "images/mtn_2.jpg"
    @side_title = "TBD"
    erb :sarlinks
  end

  get '/sgallery' do
    @hdr_img = "images/hills.jpg"
    @side_title = "TBD"
    erb :sgallery
  end

  get '/join' do
    @hdr_img = "images/helo.jpg"
    @side_title = "TBD"
    erb :join
  end

  get '/bamruinfo' do
    @hdr_img = "images/approach.jpg"
    @side_title = "TBD"
    erb :bamruinfo
  end

  get '/calendar' do
    @hdr_img = "images/mtn.jpg"
    @side_title = "TBD"
    erb :calendar
  end

end
