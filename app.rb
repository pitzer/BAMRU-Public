base_dir = File.dirname(File.expand_path(__FILE__))
require 'rubygems'
require 'yaml'
require 'rack-flash'
require base_dir + '/config/environment'
require 'uri'
require 'net/http'
require 'daemons'
require 'sinatra/cache_assets'

class BamruApp < Sinatra::Base
  helpers Sinatra::AppHelpers

  use Sinatra::CacheAssets, :max_age => 180000

  configure do
    enable :sessions         # to store login state and calendar search settings
    use Rack::Flash          # for error and success messages
    set :erb, :trim => '-'   # strip whitespace when using <% -%>
    set :views,  File.expand_path(File.dirname(__FILE__)) + '/views'
    set :public, File.expand_path(File.dirname(__FILE__)) + '/public'
    set :static, true
  end

  # ----- PUBLIC PAGES -----

  # home page is static html...
  get '/' do
    redirect "/index.html"
  end

  get '/bamruinfo' do
    expires 180000, :public, :must_revalidate
    last_modified last_modification_date
    @title     = "Information about BAMRU"
    @hdr_img   = "images/approach.jpg"
    @right_nav = right_nav(:bamruinfo)
    @left_txt  = quote
    erb :bamruinfo
  end

  get '/join' do
    expires 180000, :public, :must_revalidate
    last_modified last_modification_date
    @title     = "Joining BAMRU"
    @hdr_img   = "images/helo.jpg"
    @right_nav = right_nav(:join)
    @right_txt = quote
    erb :join
  end

  get '/sgallery' do
    expires 180000, :public, :must_revalidate
    last_modified last_modification_date
    @title     = "BAMRU Photo Gallery"
    @hdr_img   = "images/hills.jpg"
    @right_nav = right_nav(:sgallery)
    @right_txt = PHOTO_RIGHT
    @left_txt  = PHOTO_LEFT
    erb :sgallery
  end

  get '/meeting_locations' do
    expires 180000, :public, :must_revalidate
    last_modified last_modification_date
    @title     = "BAMRU Meeting Location"
    @hdr_img   = "images/mtn_2.jpg"
    @right_nav = right_nav(:meeting_locations)
    @right_txt = quote
    erb :meeting_locations
  end

  get '/sarlinks' do
    expires 180000, :public, :must_revalidate
    last_modified last_modification_date
    @title     = "Links to SAR-related sites"
    @hdr_img   = "images/glacier.jpg"
    @right_nav = right_nav(:sarlinks)
    @right_txt = quote
    erb :sarlinks
  end

  get '/donate' do
    expires 180000, :public, :must_revalidate
    last_modified last_modification_date
    @title     = "Donate to BAMRU"
    @hdr_img   = "images/glacier.jpg"
    @right_nav = right_nav(:donate)
    @right_txt = quote
    erb :donate
  end

  get '/caltopo' do
    expires 180000, :public, :must_revalidate
    last_modified last_modification_date
    @title     = "CalTopo"
    @hdr_img   = "images/glacier.jpg"
    @right_nav = right_nav(:donate)
    @right_txt = quote
    erb :caltopo
  end

  get '/backlog' do
    expires 180000, :public, :must_revalidate
    last_modified last_modification_date
    @title     = "Equipment Backlog"
    @hdr_img   = "images/glacier.jpg"
    @right_nav = right_nav(:donate)
    @right_txt = quote
    erb :backlog
  end

  get '/contact' do
    expires 180000, :public, :must_revalidate
    last_modified last_modification_date
    @title     = "BAMRU Contacts"
    @hdr_img   = "images/HawthornLZ.jpg"
    @right_nav = right_nav(:contact)
    @right_txt = quote
    erb :contact
  end

  get '/calendar' do
    expires 60, :public, :must_revalidate
    last_modified last_db_update_date
    # establish the start and finish range
    @start  = Event.date_parse(select_start_date)
    @finish = Event.date_parse(select_finish_date)
    @start, @finish  = @finish, @start if @finish < @start
    # remember start/finish settings by saving them in the session
    session[:start]  = @start
    session[:finish] = @finish
    # setup the display variables
    @title     = "BAMRU Calendar"
    @hdr_img   = "images/mtn.jpg"
    @right_nav = right_nav(:calendar)
    @right_txt = erb GUEST_POLICY, :layout => false
    @left_txt  = quote
    erb :calendar
  end

  get '/calendar.ical' do
    expires 60, :public, :must_revalidate
    last_modified last_db_update_date
    response["Content-Type"] = "text/plain"
    @actions = Event.all
    erb :calendar_ical, :layout => false
  end

  get '/calendar.csv' do
    expires 300, :public, :must_revalidate
    last_modified last_db_update_date
    response["Content-Type"] = "text/plain"
    @actions = Event.all
    erb :calendar_csv, :layout => false
  end

  get '/calendar.gcal' do
    expires 300, :public, :must_revalidate
    last_modified last_db_update_date
    @title     = "BAMRU's Google Calendar"
    @hdr_img   = "images/glacier.jpg"
    @right_nav = quote
    erb :calendar_gcal
  end

  get '/operations' do
    expires 300, :public, :must_revalidate
    last_modified last_db_update_date
    # establish the start and finish range
    @start  = Event.date_parse(select_start_operation)
    @finish = Event.date_parse(select_finish_operation)
    @start, @finish  = @finish, @start if @finish < @start
    # remember start/finish settings by saving them in the session
    session[:start_operation]  = @start
    session[:finish_operation] = @finish
    # display variables
    @title     = "BAMRU Operations"
    @hdr_img   = "images/glacier.jpg"
    range      = "range=#{@start.to_label}_#{@finish.to_label}"
    @filename  = "operations#{(rand * 10000).round}.kml?#{range}"
    @right_nav = quote
    @right_txt = erb BIG_MAP, :layout => false
    erb :operations
  end

  get "/operations*.kml*" do
    expires 300, :public, :must_revalidate
    last_modified last_db_update_date
    # establish the start and finish range
    @start  = Event.date_parse(select_start_operation)
    @finish = Event.date_parse(select_finish_operation)
    @start, @finish  = @finish, @start if @finish < @start
    # remember start/finish settings by saving them in the session
    session[:start_operation]  = @start
    session[:finish_operation] = @finish
    # display variables
    response["Content-Type"] = "text/plain"
    @operations = Event.operations.between(@start, @finish)
    erb :operations_kml, :layout => false
  end

  # ----- LANDING PAGES -----

  get '/truck2012' do
    #expires 180000, :public, :must_revalidate
    #last_modified last_modification_date
    @title     = "BAMRU Truck Campaign"
    @hdr_img   = "images/approach.jpg"
    @right_nav = erb(:thermometer, :layout => false)
    @left_txt  = quote
    erb :truck2012
  end

  # ----- ADMIN PAGES -----

  before '/admin*' do
    @sitep ||= Settings.new
    protected!
  end

  get '/admin' do
    redirect '/admin_home'
  end

  get '/admin_home' do
    erb :admin_home, :layout => :admin_x_layout
  end

  get '/admin_events' do
    # select start / finish dates
    @start  = Event.date_parse(select_start_date)
    @finish = Event.date_parse(select_finish_date)
    @start, @finish = @finish, @start if @finish < @start
    # remember start/finish dates by saving them in the session
    session[:start] = @start
    session[:finish] = @finish
    erb :admin_events, :layout => :admin_x_layout
  end

  get '/admin_create' do
    @action      = Event.new
    @post_action = "/admin_create"
    @button_text = "Create"
    erb :admin_create, :layout => :admin_x_layout
  end

  get '/admin_copy/:id' do
    @action      = Event.find_by_id(params[:id])
    @post_action = "/admin_create"
    @button_text = "Create"
    erb :admin_create, :layout => :admin_x_layout
  end

  post '/admin_create' do
    params.delete "submit"
    action = Event.new(params)
    if action.save
      background { GcalSync.create_event(action) }
      background { CsvHistory.save }
      set_flash_notice("Created New Event (#{action.kind.capitalize} > #{action.title} > #{action.start})")
      redirect '/admin_events'
    else
      set_flash_error("<u>Input Error(s) - Please Try Again</u><br/>#{error_text(action.errors)}")
      @action      = action
      @post_action = "/admin_create"
      @button_text = "Create"
      erb :admin_new, :layout => :admin_x_layout
    end
  end

  get '/admin_show/:id' do
    @action      = Event.find_by_id(params[:id])
    erb :admin_show, :layout => :admin_x_layout
  end

  get '/admin_edit/:id' do
    @action      = Event.find_by_id(params[:id])
    @post_action = "/admin_update/#{params[:id]}"
    @button_text = "Update"
    erb :admin_edit, :layout => :admin_x_layout
  end

  post '/admin_update/:id' do
    action = Event.find_by_id(params[:id])
    params.delete "submit"
    if action.update_attributes(params)
      background { GcalSync.update_event(action) }
      background { CsvHistory.save }
      set_flash_notice("Updated Event (#{action.kind.capitalize} > #{action.title} > #{action.start})")
      redirect '/admin_events'
    else
      set_flash_error("<u>Input Error(s) - Please Try Again</u><br/>#{error_text(action.errors)}")
      @action      = action
      @post_action = "/admin_create"
      @button_text = "Update"
      erb :admin_edit, :layout => :admin_x_layout
    end
  end

  get '/admin_delete/:id' do
    action = Event.find_by_id(params[:id])
    set_flash_notice("Deleted Event (#{action.kind.capitalize} > #{action.title} > #{action.start})")
    action.destroy
    background { GcalSync.delete_event(action) }
    background { CsvHistory.save }
    redirect "/admin_events"
  end

    get '/admin_data' do
    erb :admin_data, :layout => :admin_x_layout
  end

  # duplication with admin_data_url - needs refactoring
  post('/admin_data_file') do
    if params[:file].nil?
      set_flash_error("Error - no CSV file was selected")
      redirect '/admin_data'
    end
    csv_text = params[:file][:tempfile].read
    if params["mode"] == "overwrite"
      Event.delete_all if CsvLoader.load_ready?(csv_text)
    end
    csv_load = CsvLoader.new(csv_text)
    if csv_load.errors?
      set_flash_error(csv_load.error_message)
      redirect('/admin_data')
    end
    set_flash_error(csv_load.warning_message) if csv_load.warnings?
    set_flash_notice(csv_load.success_message)
    background { CsvHistory.save }
    redirect('/admin_events')
  end

  # duplication with admin_data_url - needs refactoring
  post('/admin_data_url') do
    if params[:peer_url].nil?
      set_flash_error("Error - no peer CSV was selected")
      redirect '/admin_data'
    end
    url = params[:peer_url]
    uri = URI.parse(url)
    csv_text = Net::HTTP.get_response(uri.host, uri.path).body
    if params["mode"] == "overwrite"
      Event.delete_all if CsvLoader.load_ready?(csv_text)
    end
    csv_load = CsvLoader.new(csv_text)
    if csv_load.errors?
      set_flash_error(csv_load.error_message)
      background { CsvHistory.save }
      redirect('/admin_data')
    end
    set_flash_error(csv_load.warning_message) if csv_load.warnings?
    set_flash_notice(csv_load.success_message)
    redirect('/admin_events')
  end

  get '/admin_settings' do
    erb :admin_settings, :layout => :admin_x_layout
  end

  post '/admin_settings' do
    sitep = Settings.new(params)
    if sitep.save
      set_flash_notice("Updated Settings")
      if sitep.peer_url_defined? && sitep.primary? && @sitep.password != sitep.password
        url = "#{sitep.peer_url}/update_pwd?passwd=#{params['password']}"
        uri = URI.parse(url)
        #status = Net::HTTP.get_response(uri.host, uri.path).body
        status = Net::HTTP.get_response(URI.parse(url)).body
        puts "\nPassword Update Error Message\n#{status}"     unless status == "OK"
        set_flash_error("Problem updating password on Backup site") unless status == "OK"
      end
      redirect '/admin_settings'
      else
        set_flash_error("<u>Input Error(s) - Please Try Again</u><br/>#{error_text(sitep.errors)}")
        @sitep = Settings.new
        erb :admin_settings, :layout => :admin_x_layout#
      end
    end
  
  get '/admin_inval_csv' do
    response["Content-Type"] = "text/plain"
    File.read(INVAL_CSV_FILENAME)
  end

  get '/admin_inval_rec' do
    response["Content-Type"] = "text/plain"
    File.read(INVAL_REC_FILENAME)
  end

  get '/update_pwd' do
    @sitep = Settings.new
    return "Error: incorrect password" unless params[:passwd]
    return "Error: not a backup site" unless @sitep.backup?
    return "Error: no peer url" unless @sitep.peer_url_defined?
    return "Error: unrecognized peer" unless request.env['REMOTE_ADDR'] == @sitep.peer_address
    @sitep.password = params[:passwd]
    return "Error: invalid password" unless @sitep.valid?
    @sitep.save
    "OK"
  end

  not_found do
    @right_nav = quote
    @hdr_img   = "images/mtn.jpg"
    erb :not_found
  end

end
