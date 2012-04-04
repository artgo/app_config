module AppConfigSetup
  class Railtie < Rails::Railtie
    initializer "railtie.configure_rails_initialization" do
      AppConfig.config_dir= "#{Rails.root.to_s}/config/"
      c = AppConfig.new
      c.load_config!("config")
      c.use_section!(Rails.env)
      ::Conf = c
    end
  end
end
