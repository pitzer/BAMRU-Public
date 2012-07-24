require 'gcal4ruby'
require 'yaml'

class GcalSync

  include GCal4Ruby

  # ----- Utility Methods -----

  def self.get_current_actions_from_database
    ::Event.between(::Event.default_start, ::Event.default_end)
  end

  def self.authenticate_and_return_gcal_service
    service = Service.new
    service.authenticate(GCAL_USER, GCAL_PASS)
    service
  end

  def self.save_event_to_gcal(service, event, action)
    return if action.kind == "operation"
    event.calendar    = service.calendars.first
    event.title       = action.title
    event.start_time  = action.gcal_start
    event.end_time    = action.gcal_finish
    event.all_day     = action.gcal_all_day?
    event.content     = action.gcal_content
    event.where       = action.gcal_location
    event.save
  end

  def self.count_gcal_events
    service = authenticate_and_return_gcal_service
    cal     = service.calendars.first
    cal.events.length
  end

  # ----- Batch Sync Functions -----
  # - called by command-line tool to completely resync the calendars

  def self.delete_all_gcal_events
    service = authenticate_and_return_gcal_service
    cal     = service.calendars.first
    cal.events.each do |event|
      puts "Deleting #{event.title}"
      event.delete
    end
    "OK"
  end

  def self.add_all_current_actions_to_gcal
    service = authenticate_and_return_gcal_service
    get_current_actions_from_database.each do |action|
      if action.kind != "operation"
        puts "Adding #{action.title} (#{action.id})"
        event = Event.new(service)
        save_event_to_gcal(service, event, action)
      end
    end
    "OK"
  end

  def self.sync
    2.times { delete_all_gcal_events }
    add_all_current_actions_to_gcal
  end

  # ----- Event-Driven Sync Functions -----
  # - called by WebApp during CRUD operations

  def self.create_event(action)
    return if action.kind == "operation"
    service = authenticate_and_return_gcal_service
    event   = Event.new(service)
    puts "Creating #{action.id}"
    save_event_to_gcal(service, event, action)
  end

  def self.update_event(action)
    return if action.kind == "operation"
    delete_event(action.id)
    create_event(action)
  end

  def self.delete_event(id)
    service = authenticate_and_return_gcal_service
    events  = Event.find(service, "BE#{id}")
    events.each {|ev| puts "Deleting #{id}" ; ev.delete }
  end

end