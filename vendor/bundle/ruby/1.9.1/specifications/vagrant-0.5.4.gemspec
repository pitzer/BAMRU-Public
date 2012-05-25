# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "vagrant"
  s.version = "0.5.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mitchell Hashimoto", "John Bender"]
  s.date = "2010-09-07"
  s.description = "Vagrant is a tool for building and distributing virtualized development environments."
  s.email = ["mitchell.hashimoto@gmail.com", "john.m.bender@gmail.com"]
  s.executables = [".gitignore", "vagrant"]
  s.files = ["bin/.gitignore", "bin/vagrant"]
  s.homepage = "http://vagrantup.com"
  s.require_paths = ["lib"]
  s.rubyforge_project = "vagrant"
  s.rubygems_version = "1.8.23"
  s.summary = "Build and distribute virtualized development environments."

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<virtualbox>, ["~> 0.7.3"])
      s.add_runtime_dependency(%q<net-ssh>, [">= 2.0.19"])
      s.add_runtime_dependency(%q<net-scp>, [">= 1.0.2"])
      s.add_runtime_dependency(%q<json>, [">= 1.4.3"])
      s.add_runtime_dependency(%q<archive-tar-minitar>, ["= 0.5.2"])
      s.add_runtime_dependency(%q<mario>, ["~> 0.0.6"])
      s.add_runtime_dependency(%q<erubis>, [">= 2.6.6"])
      s.add_development_dependency(%q<rake>, [">= 0"])
      s.add_development_dependency(%q<contest>, [">= 0.1.2"])
      s.add_development_dependency(%q<mocha>, [">= 0"])
      s.add_development_dependency(%q<ruby-debug>, [">= 0"])
      s.add_development_dependency(%q<bundler>, [">= 1.0.0.rc.5"])
    else
      s.add_dependency(%q<virtualbox>, ["~> 0.7.3"])
      s.add_dependency(%q<net-ssh>, [">= 2.0.19"])
      s.add_dependency(%q<net-scp>, [">= 1.0.2"])
      s.add_dependency(%q<json>, [">= 1.4.3"])
      s.add_dependency(%q<archive-tar-minitar>, ["= 0.5.2"])
      s.add_dependency(%q<mario>, ["~> 0.0.6"])
      s.add_dependency(%q<erubis>, [">= 2.6.6"])
      s.add_dependency(%q<rake>, [">= 0"])
      s.add_dependency(%q<contest>, [">= 0.1.2"])
      s.add_dependency(%q<mocha>, [">= 0"])
      s.add_dependency(%q<ruby-debug>, [">= 0"])
      s.add_dependency(%q<bundler>, [">= 1.0.0.rc.5"])
    end
  else
    s.add_dependency(%q<virtualbox>, ["~> 0.7.3"])
    s.add_dependency(%q<net-ssh>, [">= 2.0.19"])
    s.add_dependency(%q<net-scp>, [">= 1.0.2"])
    s.add_dependency(%q<json>, [">= 1.4.3"])
    s.add_dependency(%q<archive-tar-minitar>, ["= 0.5.2"])
    s.add_dependency(%q<mario>, ["~> 0.0.6"])
    s.add_dependency(%q<erubis>, [">= 2.6.6"])
    s.add_dependency(%q<rake>, [">= 0"])
    s.add_dependency(%q<contest>, [">= 0.1.2"])
    s.add_dependency(%q<mocha>, [">= 0"])
    s.add_dependency(%q<ruby-debug>, [">= 0"])
    s.add_dependency(%q<bundler>, [">= 1.0.0.rc.5"])
  end
end
