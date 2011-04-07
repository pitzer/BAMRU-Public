require 'gcal4ruby'
require 'ruby-debug'

class GcalSync
  USERNAME = "bamru.calendar@gmail.com"
  PASSWORD = "bamcalendar"

  include GCal4Ruby

  def self.get_current_actions
    Action.between(Action.default_start, Action.default_end)
  end

  def self.count_gcal_events
    service = Service.new
    service.authenticate(USERNAME, PASSWORD)
    cal = service.calendars.first
    cal.events.length
  end

  def self.delete_all_gcal_events
    service = Service.new
    service.authenticate(USERNAME, PASSWORD)
    cal = service.calendars.first
    cal.events.each do |event|
      puts "Deleting #{event.title}"
      event.delete
    end
    cal.events.each do |event|
      puts "Deleting #{event.title}"
      event.delete
    end
    "OK"
  end

  def self.add_current_actions
    service = Service.new
    service.authenticate(USERNAME, PASSWORD)
    cal = service.calendars.first
    get_current_actions.each do |action|
      debugger if action.gcal_finish.class != Time
      puts "Adding #{action.title.ljust(18)[0..17]} #{action.gcal_start} | #{action.gcal_finish}"
      event = Event.new(service)
      event.title       = action.title
      event.calendar    = cal
      event.start_time  = action.gcal_start
      event.end_time    = action.gcal_finish
      event.all_day     = action.gcal_all_day?
      event.content     = action.description
      event.where       = action.location
      event.save
    end
    "OK"
  end

  def self.sync
    delete_all_gcal_events
    add_current_actions
  end

end