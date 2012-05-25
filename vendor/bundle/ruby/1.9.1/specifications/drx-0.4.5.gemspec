# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "drx"
  s.version = "0.4.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mooffie"]
  s.date = "2010-04-20"
  s.email = "mooffie@gmail.com"
  s.extensions = ["ext/extconf.rb"]
  s.files = ["ext/extconf.rb"]
  s.homepage = "http://drx.rubyforge.org/"
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.2")
  s.rubyforge_project = "drx"
  s.rubygems_version = "1.8.23"
  s.summary = "Object inspector for Ruby."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
