# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "interact"
  s.version = "0.4.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Alex Suraci"]
  s.date = "2012-04-03"
  s.description = "A simple API for command-line interaction. Provides a novel 'rewinding' feature, allowing users to go back in time and re-enter a botched answer. Supports multiple-choice, password prompting, overriding input events, defaults, etc."
  s.email = "i.am@toogeneric.com"
  s.extra_rdoc_files = ["README.md", "LICENSE"]
  s.files = ["README.md", "LICENSE"]
  s.homepage = "http://github.com/vito/interact"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "A simple API for command-line interaction."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.0"])
    else
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.0"])
    end
  else
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.0"])
  end
end
