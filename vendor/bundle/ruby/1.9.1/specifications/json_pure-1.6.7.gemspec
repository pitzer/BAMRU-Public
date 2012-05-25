# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "json_pure"
  s.version = "1.6.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Florian Frank"]
  s.date = "2012-04-28"
  s.description = "This is a JSON implementation in pure Ruby."
  s.email = "flori@ping.de"
  s.extra_rdoc_files = ["README.rdoc"]
  s.files = ["README.rdoc"]
  s.homepage = "http://flori.github.com/json"
  s.rdoc_options = ["--title", "JSON implemention for ruby", "--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "json"
  s.rubygems_version = "1.8.23"
  s.summary = "JSON Implementation for Ruby"

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<permutation>, [">= 0"])
      s.add_development_dependency(%q<sdoc>, [">= 0"])
      s.add_development_dependency(%q<rake>, ["~> 0.9.2"])
    else
      s.add_dependency(%q<permutation>, [">= 0"])
      s.add_dependency(%q<sdoc>, [">= 0"])
      s.add_dependency(%q<rake>, ["~> 0.9.2"])
    end
  else
    s.add_dependency(%q<permutation>, [">= 0"])
    s.add_dependency(%q<sdoc>, [">= 0"])
    s.add_dependency(%q<rake>, ["~> 0.9.2"])
  end
end
