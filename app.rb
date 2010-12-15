class BamruApp < Sinatra::Base

  helpers do
    def current_page
      request.path_info
    end

    def menu_link(target, label)
      cls = current_page == target ? "nav4" : "nav1"
      <<-HTML
      <a href='#{target}' class='#{cls}' onfocus='blur();'>#{label}</a><br/>
      HTML
    end
  end

  get '/' do
    redirect "/index.html"
  end

  get '/contact.test' do
    @hdr_img = "images/HawthornLZ.jpg"
    @side_title = "CONTACT"
    erb :contact
  end

  get '/donate.test' do
    @hdr_img = "images/glacier.jpg"
    @side_title = "Donate to BAMRU"
    erb :donate
  end
end
