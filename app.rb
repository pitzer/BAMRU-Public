base_dir = File.dirname(File.expand_path(__FILE__))
require 'rubygems'
require 'yaml'
require 'ruby-debug'
require 'rack-flash'
require base_dir + '/config/environment'
require base_dir + '/app_helpers'

class BamruApp < Sinatra::Base
  helpers Sinatra::AppHelpers

  configure do
    enable :sessions
    use Rack::Flash
    set :erb, :trim => '-'
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
    erb :admin, :layout => :admin_layout
  end

  get '/admin_show' do
    erb :admin_show, :layout => :admin_layout
  end

  get '/admin_new' do
    @event       = Event.new
    @action      = "/admin_create"
    @button_text = "Create Event"
    erb :admin_new, :layout => :admin_layout
  end

  get '/admin_copy/:id' do
    @event       = Event.find_by_id(params[:id])
    @action      = "/admin_create"
    @button_text = "Create Event"
    erb :admin_new, :layout => :admin_layout
  end

  post '/admin_create' do
    params.delete "submit"
    event = Event.new(params)
    if event.save
      set_flash_notice("Created new event (#{event.kind}/#{event.title})")
      redirect '/admin_show'
    else
      @event = event
      @action = "/admin_create"
      @button_text = "Create Event"
      set_flash_error("Invalid parameter - try again")
      erb :admin_new, :layout => :admin_layout
    end
  end

  get '/admin_edit/:id' do
    @event       = Event.find_by_id(params[:id])
    @action      = "/admin_update/#{params[:id]}"
    @button_text = "Update Event"
    erb :admin_edit, :layout => :admin_layout
  end

  post '/admin_update/:id' do
    event = Event.find_by_id(params[:id])
    params.delete "submit"
    if event.update_attributes(params)
      set_flash_notice("Updated Event (#{event.kind}/#{event.title})")
      redirect '/admin_show'
    else
      @event = event
      @action = "/admin_create"
      @button_text = "Update Event"
      set_flash_error("Invalid parameter - try again")
      erb :admin_edit, :layout => :admin_layout
    end

  end

  get '/admin_delete/:id' do
    event = Event.find_by_id(params[:id])
    set_flash_notice "Deleted #{event.title}"
    event.destroy
    redirect "/admin_show"
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

  post('/admin_load_csv') do
    start_count = Event.count
    system "mkdir -p #{DATA_DIR}"
    system "rm -f #{CSV_FILE}"
    infile  = params[:file][:tempfile]
    puts "IN POST" * 4
    File.open(CSV_FILE, 'w') { |f| f.write infile.read }
    csv_to_hash(read_csv).each do |r|
      h = r.to_hash
      h["kind"].downcase! unless h["kind"].nil?
      Event.create(h)
    end
    finish_count = Event.count
    if File.exist? '/tmp/bad.csv'
      csv_link = "malformed CSV records. (<a href='/bad_csv'>view</a>)"
      set_flash_error("Warning: #{`wc -l /tmp/bad.csv`.split(' ').first} #{csv_link}")
    end
    set_flash_notice("CSV File Upload created #{finish_count - start_count} new event records.")
    redirect '/admin_show'
  end

  get '/bad_csv' do
    response["Content-Type"] = "text/plain"
    File.read('/tmp/bad.csv')
  end

  not_found do
    @right_nav = quote
    @hdr_img   = "images/mtn.jpg"
    erb :not_found
  end

end
