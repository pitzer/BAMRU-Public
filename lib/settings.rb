require 'yaml'

class Settings

  include ActiveModel::Validations
  extend  ActiveModel::Callbacks
  extend  ActiveModel::Naming

  # ----- Constants and Attributes -----

  DATA_DIR = File.dirname(File.expand_path(__FILE__)) + "/../data"
  DATA_FILE = DATA_DIR + "/settings.yaml"

  attr_accessor :password, :site_role, :peer_url
  attr_accessor :alert_email, :notif_email
  attr_accessor :auto_sync

  # ----- Create and Save Methods -----

  def initialize(params = {}, file = DATA_FILE)
    new_params   = read_params_from_yaml_file(file).merge(params)
    @password    = new_params["password"]    || "admin"
    @peer_url    = new_params["peer_url"]    || "http://bamru.info"
    @site_role   = new_params["site_role"]   || "Public"
    @auto_sync   = new_params["auto_sync"]   || "true"
    @alert_email = new_params["alert_email"] || "akleak@gmail.com"
    @notif_email = new_params["notif_email"] || "andy@r210.com"
  end

  def save(file = DATA_FILE)
    File.open(file, 'w') {|f| f.puts YAML.dump(self)} if valid?
    valid?
  end

  # ----- Validations -----
  validates_format_of :site_role, :with => /Public|Backup/
  validates_format_of :auto_sync, :with => /true|false/
  validates_length_of :password,  :within => 4..12


  # ----- Callbacks -----

  define_model_callbacks :save

  before_save :reset_peer_url

  
  # ----- Instance Methods -----

  def reset_peer_url
    @peer_url = "NONE" if @peer_url.nil? || @peer_url.empty?
  end

  def params_hash
    {"password"    => @password,
     "peer_url"    => @peer_url,
     "site_role"   => @site_role,
     "auto_sync"   => @auto_sync,
     "alert_email" => @alert_email,
     "notif_email" => @notif_email
    }
  end
  
  # ----- Private Methods -----

  private

  def read_params_from_yaml_file(file = DATA_FILE)
    return {} unless File.exist?(file)
    YAML.load(File.read(file)).params_hash
  end


end