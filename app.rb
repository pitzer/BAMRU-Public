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
    @start  = Action.date_parse(params[:start]  || session[:start]  || Action.default_start)
    @finish = Action.date_parse(params[:finish] || session[:finish] || Action.default_end)
    @start, @finish = @finish, @start if @finish < @start
    session[:start] = @start
    session[:finish] = @finish
    @title     = "BAMRU Calendar"
    @hdr_img   = "images/mtn.jpg"
    @right_nav = right_nav(:calendar)
    @right_txt = erb GUEST_POLICY, :layout => false
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
    @right_txt = PHOTO_RIGHT
    @left_txt  = PHOTO_LEFT
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
    @start  = Action.date_parse(params[:start]  || session[:start] ||  Action.default_start)
    @finish = Action.date_parse(params[:finish] || session[:finish] || Action.default_end)
    @start, @finish = @finish, @start if @finish < @start
    session[:start] = @start
    session[:finish] = @finish
    erb :admin_show, :layout => :admin_layout
  end

  get '/admin_new' do
    @action       = Action.new
    @action      = "/admin_create"
    @button_text = "Create Action"
    erb :admin_new, :layout => :admin_layout
  end

  get '/admin_copy/:id' do
    @action       = Action.find_by_id(params[:id])
    @action      = "/admin_create"
    @button_text = "Create Action"
    erb :admin_new, :layout => :admin_layout
  end

  post '/admin_create' do
    params.delete "submit"
    action = Action.new(params)
    if action.save
      set_flash_notice("Created New Action (#{action.kind.capitalize} > #{action.title} > #{action.start})")
      redirect '/admin_show'
    else
      set_flash_error("<u>Input Error(s) - Please Try Again</u><br/>#{error_text(action.errors)}")
      @action = action
      @action = "/admin_create"
      @button_text = "Create Action"
      erb :admin_new, :layout => :admin_layout
    end
  end

  get '/admin_edit/:id' do
    @action       = Action.find_by_id(params[:id])
    @action      = "/admin_update/#{params[:id]}"
    @button_text = "Update Action"
    erb :admin_edit, :layout => :admin_layout
  end

  post '/admin_update/:id' do
    action = Action.find_by_id(params[:id])
    debugger
    params.delete "submit"
    if action.update_attributes(params)
      set_flash_notice("Updated Action (#{action.kind.capitalize} > #{action.title} > #{action.start})")
      redirect '/admin_show'
    else
      set_flash_error("<u>Input Error(s) - Please Try Again</u><br/>#{error_text(action.errors)}")
      @action = action
      @action = "/admin_create"
      @button_text = "Update Action"
      erb :admin_edit, :layout => :admin_layout
    end

  end

  get '/admin_delete/:id' do
    action = Action.find_by_id(params[:id])
    set_flash_notice("Deleted Action (#{action.kind.capitalize} > #{action.title} > #{action.start})")
    action.destroy
    redirect "/admin_show"
  end

  get '/calendar.ical' do
    response["Content-Type"] = "text/plain"
    @actions = Action.all
    erb :admin_export_ical, :layout => false
  end

  get '/calendar.csv' do
    response["Content-Type"] = "text/plain"
    @actions = Action.all
    erb :admin_export_csv, :layout => false
  end

  get '/admin_load_csv' do
    erb :admin_load_csv, :layout => :admin_layout
  end

  post('/admin_load_csv') do
    start_count = Action.count
    system "mkdir -p #{DATA_DIR}"
    system "rm -f #{CSV_FILE}"
    system "rm -f /tmp/invalid.csv"
    if params[:file].nil?
      set_flash_error("Error - no CSV file was selected")
      redirect '/admin_load_csv'
    end
    infile  = params[:file][:tempfile]
    File.open(CSV_FILE, 'w') { |f| f.write infile.read }
    csv_to_hash(read_csv).each do |r|
      h = r.to_hash
      h["kind"].downcase! unless h["kind"].nil?
      record = Action.create(h)
      unless record.valid?
        File.open('/tmp/invalid.csv', 'a') {|f| f.puts r; f.puts record.errors.inspect}
      end
    end
    finish_count = Action.count
    if File.exist? '/tmp/malformed.csv'
      csv_link = "malformed CSV records. (<a href='/malformed_csv'>view</a>)"
      set_flash_error(" Warning: #{`wc -l /tmp/malformed.csv`.split(' ').first} #{csv_link}")
    end
    if File.exist? '/tmp/invalid.csv'
      csv_link = "invalid CSV records. (<a href='/invalid_csv'>view</a>)"
      set_flash_error(" Warning: #{`wc -l /tmp/invalid.csv`.split(' ').first} #{csv_link}")
    end
    set_flash_notice("CSV File Upload created #{finish_count - start_count} new actions.")
    redirect '/admin_show'
  end

  get '/malformed_csv' do
    response["Content-Type"] = "text/plain"
    File.read('/tmp/malformed.csv')
  end

  get '/invalid_csv' do
    response["Content-Type"] = "text/plain"
    File.read('/tmp/invalid.csv')
  end

  not_found do
    @right_nav = quote
    @hdr_img   = "images/mtn.jpg"
    erb :not_found
  end

end
