# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "app_config"
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Eugene Bolshakov"]
  s.date = "2012-04-05"
  s.description = "Provides configuration from yml services to rails applications."
  s.email = "eugene.bolshakov@gmail.com"
  s.extra_rdoc_files = ["README", "lib/app_config.rb"]
  s.files = ["Manifest", "README", "Rakefile", "init.rb", "lib/app_config.rb", "test/app_config_test.rb", "app_config.gemspec"]
  s.homepage = "http://github.com/artgo/app_config"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "App_config", "--main", "README"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "app_config"
  s.rubygems_version = "1.8.15"
  s.summary = "Provides configuration from yml services to rails applications."
  s.test_files = ["test/app_config_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
