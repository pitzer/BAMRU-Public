require 'sinatra/base'

module Sinatra
  module AppHelpers

    BASE_DIR  = File.dirname(File.expand_path(__FILE__))
    DATA_DIR  = BASE_DIR + "/data"
    CSV_FILE  = DATA_DIR + "/data.csv"
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

    def select_helper(event)
      vals = {"meeting"    => "Meeting",
              "training"   => "Training",
              "event"      => "Event",
              "non_county" => "Non-County Meeting"}
      vals.keys.map do |i|
        opt = i == event.kind ? " selected" : ""
        "<option value='#{i}'#{opt}>#{vals[i]}</option>"
      end.join(' ')
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
        output << "<tr><td>#{m.title} / #{m.location}</td><td>#{m.start}</td><td>#{m.leaders}</td><td class='ac'><nobr>#{event_edit_link(m.id)} | #{event_delete_link(m.id)}</nobr></td></tr>"
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
              ['/admin',          'Admin Home'],
              ['/admin_show',     'Edit Events'],
              ['/admin_new',      'Create Event'],
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

  require 'fastercsv'  

  def read_csv
    system "rm -f /tmp/bad.csv"
    bad_csv = ""
    output = File.read(CSV_FILE).reduce([]) do |a,v|
      begin
        a << v.parse_csv
      rescue
        puts "BAD RECORD FOUND!! >> #{v[0..30]}"
        bad_csv << v
      end
      a
    end
    File.open('/tmp/bad.csv', 'w') {|f| f.puts bad_csv} unless bad_csv.empty?
    output
  end

  def csv_to_hash(data)
    headers = data.first
    fields  = data[1..-1]
    fields.reduce([]) do |a,v|
      a << FasterCSV::Row.new(headers, v)
      a
    end
  end
        
  end

  helpers AppHelpers

end

