require 'rubygems'
require 'rake'
require 'echoe'

Echoe.new('app_config', '1.0.0') do |p|
  p.description    = "Provides configuration from yml services to rails applications."
  p.url            = "http://github.com/artgo/app_config"
  p.author         = "Eugene Bolshakov"
  p.email          = "eugene.bolshakov@gmail.com"
  p.ignore_pattern = ["tmp/*", "script/*"]
  p.development_dependencies = []
end

Dir["#{File.dirname(__FILE__)}/tasks/*.rake"].sort.each { |ext| load ext }