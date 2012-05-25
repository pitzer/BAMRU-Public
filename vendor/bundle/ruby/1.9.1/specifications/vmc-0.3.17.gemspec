# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "vmc"
  s.version = "0.3.17"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["VMware"]
  s.date = "2012-04-27"
  s.description = "Client library and CLI that provides access to the VMware Cloud Application Platform."
  s.email = "support@vmware.com"
  s.executables = ["vmc"]
  s.extra_rdoc_files = ["README.md", "LICENSE"]
  s.files = ["bin/vmc", "README.md", "LICENSE"]
  s.homepage = "http://vmware.com"
  s.require_paths = ["lib"]
  s.rubygems_version = "1.8.23"
  s.summary = "Client library and CLI that provides access to the VMware Cloud Application Platform."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<json_pure>, ["< 1.7.0", ">= 1.5.1"])
      s.add_runtime_dependency(%q<rubyzip>, ["~> 0.9.4"])
      s.add_runtime_dependency(%q<rest-client>, ["< 1.7.0", ">= 1.6.1"])
      s.add_runtime_dependency(%q<terminal-table>, ["~> 1.4.2"])
      s.add_runtime_dependency(%q<interact>, ["~> 0.4.0"])
      s.add_runtime_dependency(%q<addressable>, ["~> 2.2.6"])
      s.add_runtime_dependency(%q<uuidtools>, ["~> 2.1.0"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 1.3.0"])
      s.add_development_dependency(%q<webmock>, ["~> 1.5.0"])
    else
      s.add_dependency(%q<json_pure>, ["< 1.7.0", ">= 1.5.1"])
      s.add_dependency(%q<rubyzip>, ["~> 0.9.4"])
      s.add_dependency(%q<rest-client>, ["< 1.7.0", ">= 1.6.1"])
      s.add_dependency(%q<terminal-table>, ["~> 1.4.2"])
      s.add_dependency(%q<interact>, ["~> 0.4.0"])
      s.add_dependency(%q<addressable>, ["~> 2.2.6"])
      s.add_dependency(%q<uuidtools>, ["~> 2.1.0"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 1.3.0"])
      s.add_dependency(%q<webmock>, ["~> 1.5.0"])
    end
  else
    s.add_dependency(%q<json_pure>, ["< 1.7.0", ">= 1.5.1"])
    s.add_dependency(%q<rubyzip>, ["~> 0.9.4"])
    s.add_dependency(%q<rest-client>, ["< 1.7.0", ">= 1.6.1"])
    s.add_dependency(%q<terminal-table>, ["~> 1.4.2"])
    s.add_dependency(%q<interact>, ["~> 0.4.0"])
    s.add_dependency(%q<addressable>, ["~> 2.2.6"])
    s.add_dependency(%q<uuidtools>, ["~> 2.1.0"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 1.3.0"])
    s.add_dependency(%q<webmock>, ["~> 1.5.0"])
  end
end
