require 'erb'
require 'yaml'

class AppConfig
  
  def initialize(file = nil)
    @sections = {}
    @params = {}
    use_file!(file) if file
  end

  def self.config_dir=(dir)
    @@dir=dir
  end

  def load_config!(config_name, config_mandatory=true)
    use_file!("#{@@dir}#{config_name}.yml", config_mandatory)
    use_file!("#{@@dir}#{config_name}.local.yml", false)
  end
  
  def use_file!(file, throw_if_file_not_exists=true)
    if throw_if_file_not_exists || File.exists?(file)
      hash = YAML::load(ERB.new(IO.read(file)).result)

      unless hash.nil?
        @sections.merge!(hash) {|key, old_val, new_val| (old_val || new_val).merge new_val }
      end

      unless @sections['common'].nil?
        @params.merge!(@sections['common'])
      end
    end    
  end
  
  def use_section!(section)
    @params.merge!(@sections[section.to_s]) if @sections.key?(section.to_s)
  end
  
  def method_missing(param)
    param = param.to_s
    if @params.key?(param)
      @params[param]
    else
      raise "Invalid AppConfig Parameter #{param}"
    end
  end

  def params_hash!
    @params
  end

  def is_defined?(param)
    return @params.key?(param.to_s)
  end
end

require 'railtie' if defined?(Rails)