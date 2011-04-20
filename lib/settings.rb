class Settings
  DATA_DIR = File.dirname(File.expand_path(__FILE__)) + "/../data"

  attr_accessor :password, :site_role, :peer_url

  def initialize(params = {})
    @password  = params["password"]  || @password  || "admin"
    @site_role = params["site_role"] || @site_role || "Public"
    @peer_url  = params["peer_url"]  || @peer_url  || "http://bamru.info"
  end

  def load_params(params)
    from_file = read_params_from_yaml_file
  end

  def read_params_from_yaml_file

  end

end