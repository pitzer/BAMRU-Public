# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "virtualbox"
  s.version = "0.7.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mitchell Hashimoto"]
  s.date = "2010-07-20"
  s.description = "Create and modify virtual machines in VirtualBox using pure ruby."
  s.email = "mitchell.hashimoto@gmail.com"
  s.extra_rdoc_files = ["LICENSE"]
  s.files = ["LICENSE"]
  s.homepage = "http://github.com/mitchellh/virtualbox"
  s.rdoc_options = ["--charset=UTF-8"]
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "Create and modify virtual machines in VirtualBox using pure ruby."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<ffi>, [">= 0.6.3"])
    else
      s.add_dependency(%q<ffi>, [">= 0.6.3"])
    end
  else
    s.add_dependency(%q<ffi>, [">= 0.6.3"])
  end
end
