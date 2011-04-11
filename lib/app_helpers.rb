require 'sinatra/base'
require 'time'
require 'rack'

module Sinatra
  module AppHelpers

    QUOTES       = YAML.load_file(BASE_DIR + "/data/quotes.yaml")
    RIGHT_NAV    = YAML.load_file(BASE_DIR + "/data/right_nav.yaml")
    GUEST_POLICY = File.read(BASE_DIR + "/data/guest_policy.erb")
    PHOTO_LEFT   = File.read(DATA_DIR + "/photo_caption_left.html")
    PHOTO_RIGHT  = File.read(DATA_DIR + "/photo_caption_right.html")

    def protected!
      unless authorized?
        response['WWW-Authenticate'] = %(Basic realm="Restricted Area")
        throw(:halt, [401, "Not authorized\n"])
      end
    end

    def background
      puts "Starting Background Process"
      pid = fork do
        yield
      end
      Process.detach(pid)
      pid
    end

    def authorized?
      @auth ||= Rack::Auth::Basic::Request.new(request.env)
      @auth.provided? &&
              @auth.basic? &&
              @auth.credentials &&
              @auth.credentials == ['admin', 'admin']
    end

    def current_server
      "http://#{request.env["HTTP_HOST"]}"
    end

    def current_page
      request.path_info
    end

    def select_start_date
      params[:start]  || session[:start] ||  Event.default_start
    end

    def select_finish_date
      params[:finish] || session[:finish] || Event.default_end
    end

    def select_start_operation
      range = params[:range].nil? ? nil : params[:range].split('_').first
      range || params[:start]  || session[:start_operation] ||  Event.default_start_operation
    end

    def select_finish_operation
      range = params[:range].nil? ? nil : params[:range].split('_').last
      range || params[:finish] || session[:finish_operation] || Event.default_end_operation
    end

    def number_of(kind = "")
      return Event.count if kind.blank?
      Event.where(:kind => kind).count
    end

    def last_modification(file_spec = nil)
      file_spec ||= %w(app* views/*)
      Dir[*file_spec].map {|f| File.ctime(f)}.max.strftime("%a %b %d - %H:%M")
    end

    def last_restart
      File.ctime(BASE_DIR + "/tmp/restart.txt").strftime("%a %b %d - %H:%M")
    end

    def record_display(event)
      return if event.nil?
      "<b>#{event.start}</b> (<a href='/admin_edit/#{event.id}'>#{event.title[0..15]}...</a>)"
    end

    def oldest_record
      record_display Event.order('start').first
    end

    def newest_record
      record_display Event.order('start').last
    end

    def last_update
      rec = Event.order('updated_at').last
      return if rec.nil?
      "<b>#{rec.updated_at.strftime("%a %b %d - %H:%M")}</b> (<a href='/admin_edit/#{rec.id}'>#{rec.title[0..15]}...</a>)"
    end

    def link_url(url)
      "<a href='#{url}'>#{url}</a>"
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


    def calendar_table(events, link="")
      alt = false
      first = true
      events.map do |e|
        alt = ! alt
        color = alt ? "#EEEEE" : "#FFFFF"
        val = calendar_row(e, link, color, first)
        first = false
        val
      end.join
    end

    def calendar_row(event, link = '', color='#EEEEEE', first = false)
      link = event.id if link.empty?
      <<-ERB
      <tr bgcolor="#{color}">
        <td valign="top" class=summary>&nbsp;
             <a href="##{link}" class=summary>#{event.title}</a>
             <span class=copy>#{event.location}</span>
        </td>
        <td valign="top" NOWRAP class=summary>
          #{event.date_display(first)}
        </td>
        <td valign="top" NOWRAP class=summary>
          #{format_leaders(event)}
        </td>
      </tr>
      ERB
    end

    def format_leaders(event)
      return event.leaders if event.kind == 'meeting'
      event.leaders.split(',').first.split(' ').last.split('/').first
    end

    def detail_table(events)
      events.map {|e| detail_row(e)}.join
    end

    def detail_row(event)
      <<-ERB
      <p/>
      <span class="caps"><a id="#{event.id}"></a><span class="nav3">
      #{event.title}</span></span><br/>
      <span class="news10"> <font color="#888888">#{event.location}<br>
      #{event.date_display(true)}<br>      Leaders: #{event.leaders}<br><br></font></span>
  #{event.description}<br>
  <font class="caps"><img src="assets/dots.gif" width="134" height="10"></font></p>

      ERB
    end

    def action_table(events)
      output = ""
      alt   = true
      first = true
      events.each do |m|
        color = alt ? "#EEEEEE" : "#FFFFFF"
        outz = "<tr><td>#{m.title} / #{m.location}</td><td>#{m.date_display}</td><td>#{m.leaders}</td><td class='ac'><nobr>#{event_copy_link(m.id)} | #{event_edit_link(m.id)} | #{event_delete_link(m.id)}</nobr></td></tr>"
        output << action_row(m, color, first)
        first = false
        alt = ! alt
      end
      output
    end

    def action_row(event, color='#EEEEEE', first = false)
      <<-ERB
      <tr bgcolor="#{color}">
        <td valign="top" class=summary>&nbsp;
             #{event.title}
        </td>
        <td>
             <span class=copy>#{event.location}</span>
        </td>
        <td valign="top" NOWRAP class=summary>
          #{event.date_display(first)}
        </td>
        <td valign="top" NOWRAP class=summary>
          #{format_leaders(event)}
        </td>
        <td class=ac>
          <nobr>#{event_show_link(event.id)} | #{event_copy_link(event.id)} | #{event_edit_link(event.id)} | #{event_delete_link(event.id)}</nobr>
        </td>
      </tr>
      ERB
    end

    def set_flash_notice(msg)
      flash[:notice] ? flash[:notice] << msg : flash[:notice] = msg
    end

    def get_flash_notice
      var = flash[:notice]; flash[:notice] = nil
      "<div class='notice'>#{var}</div>" unless var.nil?
    end

    def set_flash_error(msg)
      flash[:error] ? flash[:error] << msg : flash[:error] = msg
    end

    def get_flash_error
      var = flash[:error]; flash[:error] = nil
      "<div class='error'>#{var}</div>" unless var.nil?
    end

    def error_text(hash)
      hash.map {|k,v| "<b>#{k}:</b> #{v}"}.join("<br/>")
    end

    def event_range_select(start, finish, direction, scope = Event)
      if direction == "start"
        opt  = start.to_label
      else
        opt  = finish.to_label
      end
      opts = scope.range_array(opt)
      output = "<select name='#{direction}'>#{opt}"
      output << opts.map do |x|
        sel = x == opt ? " SELECTED" : ""
        "<option value='#{x}'#{sel}>#{x}"
      end.join unless opts.nil?
      output << "</select>"
      output
    end

    def select_helper(action = nil)
      vals = %w(meeting training operation other)
      vals.map do |i|
        opt = i == action.kind ? " selected" : "" unless action.nil?
        "<option value='#{i}'#{opt}>#{i.capitalize}</option>"
      end.join(' ')
    end

    def event_show_link(eventid)
      "<a href='/admin_show/#{eventid}'>show</a>"
    end

    def event_copy_link(eventid)
      "<a href='/admin_copy/#{eventid}'>copy</a>"
    end

    def event_edit_link(eventid)
      "<a href='/admin_edit/#{eventid}'>edit</a>"
    end

    def event_delete_link(eventid)
      "<a href='/admin_delete/#{eventid}'>delete</a>"
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
              ['/admin',          'Admin Home'  ],
              ['/admin_index',    'Events'      ],
              ['/admin_new',      'Create Event']
      ]
      opt2 = [
              ['/calendar',      'calendar.html'],
              ['/calendar.gcal', 'calendar.gcal'],
              ['/calendar.ical', 'calendar.ical'],
              ['/calendar.csv',  'calendar.csv' ]
      ]
      r1 = opt1.map {|i| admin_link(i.first, i.last)}.join(' | ')
      r2 = opt2.map {|i| admin_link(i.first, i.last)}.join(' | ')
      "#{r1} || #{r2}<p/><hr>"
    end

    def admin_nav_footer
      opt1 = [
              ['/admin_load_csv', 'Upload CSV'      ],
              ['/admin_password', 'Admin Password'  ]
      ]
      r1 = opt1.map {|i| admin_link(i.first, i.last)}.join(' | ')
      "<hr>#{r1}"
    end

    def right_link(target, label, fmt="nav3")
      "<a href='#{target}' class='#{fmt}' onfocus='blur();'>#{label}</a><br/>"
    end

    def right_nav(page)
      fmt = "nav4"
      RIGHT_NAV[page].reduce("") do |a, v|
        val = RIGHT_NAV[page].nil? ? "" : right_link(v.last, v.first, fmt)
        fmt = "nav3"
        a << val
      end
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

    def geo_start(action)
      if action.lat.blank? || action.lon.blank?
        "startAddress: 'Redwood City, California',"
      else
        "startPositionLat: #{action.lat}, startPositionLng: #{action.lon},"
      end
    end

  end

  helpers AppHelpers

end

