# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run the gemspec command
# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{mario}
  s.version = "0.0.6"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["John Bender"]
  s.date = %q{2010-03-20}
  s.description = %q{Mario is a collection of utilities for dealing with platform specific issues}
  s.email = %q{john.m.bender@gmail.com}
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  s.files = [
    ".document",
     ".gitignore",
     "LICENSE",
     "README.rdoc",
     "Rakefile",
     "VERSION",
     "lib/mario.rb",
     "lib/mario/hats/nix.rb",
     "lib/mario/hats/windows.rb",
     "lib/mario/platform.rb",
     "mario.gemspec",
     "test/helper.rb",
     "test/mario/hats/test_nix.rb",
     "test/mario/hats/test_windows.rb",
     "test/mario/test_plaform.rb"
  ]
  s.homepage = %q{http://github.com/johnbender/mario}
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.5}
  s.summary = %q{Mario is a collection of utilities for dealing with platform specific issues}
  s.test_files = [
    "test/helper.rb",
     "test/mario/hats/test_nix.rb",
     "test/mario/hats/test_windows.rb",
     "test/mario/test_plaform.rb"
  ]

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 3

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<shoulda>, [">= 0"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
    else
      s.add_dependency(%q<shoulda>, [">= 0"])
      s.add_dependency(%q<mocha>, [">= 0"])
    end
  else
    s.add_dependency(%q<shoulda>, [">= 0"])
    s.add_dependency(%q<mocha>, [">= 0"])
  end
end
