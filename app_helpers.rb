require 'sinatra/base'

module Sinatra
  module AppHelpers

    BASE_DIR  = File.dirname(File.expand_path(__FILE__))
    QUOTES    = YAML.load_file(BASE_DIR + "/data/quotes.yaml")
    RIGHT_NAV = YAML.load_file(BASE_DIR + "/data/right_nav.yaml")
    GUEST_POLICY   = File.read(BASE_DIR + "/data/guest_policy.html")

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

  helpers AppHelpers

end


