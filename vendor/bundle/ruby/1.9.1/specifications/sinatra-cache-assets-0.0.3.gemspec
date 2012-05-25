# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "sinatra-cache-assets"
  s.version = "0.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["David Dollar"]
  s.date = "2011-02-21"
  s.email = "ddollar@gmail.com"
  s.homepage = "http://github.com/ddollar/sinatra-cache-assets"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "Add a Cache-Control header to your static assets"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<sinatra>, [">= 1.0"])
    else
      s.add_dependency(%q<sinatra>, [">= 1.0"])
    end
  else
    s.add_dependency(%q<sinatra>, [">= 1.0"])
  end
end
