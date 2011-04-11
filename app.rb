base_dir = File.dirname(File.expand_path(__FILE__))
require 'rubygems'
require 'yaml'
require 'ruby-debug'
require 'rack-flash'
require base_dir + '/config/environment'

class BamruApp < Sinatra::Base
  helpers Sinatra::AppHelpers

  configure do
    enable :sessions         # to store login state and calendar search settings
    use Rack::Flash          # for error and success messages
    set :erb, :trim => '-'   # strip whitespace when using <% -%>
  end

  # ----- PUBLIC PAGES -----

  # home page is static html...
  get '/' do
    redirect "/index-2.html"
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
    @right_txt = PHOTO_RIGHT
    @left_txt  = PHOTO_LEFT
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

  get '/calendar' do
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
    response["Content-Type"] = "text/plain"
    @actions = Event.all
    erb :export_ical, :layout => false
  end

  get '/calendar.csv' do
    response["Content-Type"] = "text/plain"
    @actions = Event.all
    erb :export_csv, :layout => false
  end

  get '/calendar.gcal' do
    @title     = "BAMRU's Google Calendar"
    @hdr_img   = "images/glacier.jpg"
    @right_nav = quote
    erb :calendar_gcal
  end

  get '/operations' do
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
    erb :operations
  end

  get "/operations*.kml*" do
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

  # ----- ADMIN PAGES -----

  get '/admin' do
    protected!
    erb :admin, :layout => :admin_layout
  end

  get '/admin_index' do
    protected!
    # select start / finish dates
    @start  = Event.date_parse(select_start_date)
    @finish = Event.date_parse(select_finish_date)
    @start, @finish = @finish, @start if @finish < @start
    # remember start/finish dates by saving them in the session
    session[:start] = @start
    session[:finish] = @finish
    erb :admin_index, :layout => :admin_layout
  end

  get '/admin_new' do
    protected!
    @action      = Event.new
    @post_action = "/admin_create"
    @button_text = "Create"
    erb :admin_new, :layout => :admin_layout
  end

  get '/admin_copy/:id' do
    protected!
    @action      = Event.find_by_id(params[:id])
    @post_action = "/admin_create"
    @button_text = "Create"
    erb :admin_new, :layout => :admin_layout
  end

  post '/admin_create' do
    protected!
    params.delete "submit"
    action = Event.new(params)
    if action.save
      background { GcalSync.create_event(action) }
      set_flash_notice("Created New Event (#{action.kind.capitalize} > #{action.title} > #{action.start})")
      redirect '/admin_index'
    else
      set_flash_error("<u>Input Error(s) - Please Try Again</u><br/>#{error_text(action.errors)}")
      @action      = action
      @post_action = "/admin_create"
      @button_text = "Create"
      erb :admin_new, :layout => :admin_layout
    end
  end

  get '/admin_show/:id' do
    protected!
    @action      = Event.find_by_id(params[:id])
    erb :admin_show, :layout => :admin_layout
  end

  get '/admin_edit/:id' do
    protected!
    @action      = Event.find_by_id(params[:id])
    @post_action = "/admin_update/#{params[:id]}"
    @button_text = "Update"
    erb :admin_edit, :layout => :admin_layout
  end

  post '/admin_update/:id' do
    protected!
    action = Event.find_by_id(params[:id])
    params.delete "submit"
    if action.update_attributes(params)
      background { GcalSync.update_event(action) }
      set_flash_notice("Updated Event (#{action.kind.capitalize} > #{action.title} > #{action.start})")
      redirect '/admin_index'
    else
      set_flash_error("<u>Input Error(s) - Please Try Again</u><br/>#{error_text(action.errors)}")
      @action      = action
      @post_action = "/admin_create"
      @button_text = "Update"
      erb :admin_edit, :layout => :admin_layout
    end

  end

  get '/admin_delete/:id' do
    protected!
    action = Event.find_by_id(params[:id])
    background { GcalSync.delete_event(action) }
    set_flash_notice("Deleted Event (#{action.kind.capitalize} > #{action.title} > #{action.start})")
    action.destroy
    redirect "/admin_index"
  end

  get '/admin_password' do
    protected!
    erb :admin_password, :layout => :admin_layout
  end

  get '/admin_load_csv' do
    protected!
    erb :admin_load_csv, :layout => :admin_layout
  end

  post('/admin_load_csv') do
    protected!
    if params[:file].nil?
      set_flash_error("Error - no CSV file was selected")
      redirect '/admin_load_csv'
    end
    File.open(MARSHALL_FILENAME, 'w') {|f| f.write params[:file][:tempfile].read}
    csv_load = CsvLoader.new(MARSHALL_FILENAME)
    set_flash_error(csv_load.error_message) if csv_load.has_errors?
    set_flash_notice(csv_load.success_message)
    redirect('/admin_index')
  end
  
  get '/malformed_csv' do
    protected!
    response["Content-Type"] = "text/plain"
    File.read(MALFORMED_FILENAME)
  end

  get '/invalid_csv' do
    protected!
    response["Content-Type"] = "text/plain"
    File.read(INVALID_FILENAME)
  end

  not_found do
    @right_nav = quote
    @hdr_img   = "images/mtn.jpg"
    erb :not_found
  end

end
