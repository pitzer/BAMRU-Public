# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "gcal4ruby"
  s.version = "0.5.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mike Reich"]
  s.date = "2010-08-14"
  s.description = "GCal4Ruby is a Ruby Gem that can be used to interact with the current version of the Google Calendar API. GCal4Ruby provides the following features: Create and edit calendar events, Add and invite users to events, Set reminders, Make recurring events."
  s.email = "mike@seabourneconsulting.com"
  s.homepage = "http://cookingandcoding.com/gcal4ruby/"
  s.require_paths = ["lib"]
  s.rubyforge_project = "gcal4ruby"
  s.rubygems_version = "1.8.23"
  s.summary = "A full featured wrapper for interacting with the Google Calendar API"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<gdata4ruby>, [">= 0.1.5"])
    else
      s.add_dependency(%q<gdata4ruby>, [">= 0.1.5"])
    end
  else
    s.add_dependency(%q<gdata4ruby>, [">= 0.1.5"])
  end
end
