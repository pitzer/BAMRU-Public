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
    @site_role   = new_params["site_role"]   || "Primary"
    @auto_sync   = new_params["auto_sync"]   || "OFF"
    @alert_email = new_params["alert_email"] || "akleak@gmail.com"
    @notif_email = new_params["notif_email"] || "andy@r210.com"
  end

  def save(file = DATA_FILE)
    File.open(file, 'w') {|f| f.puts YAML.dump(self)} if valid?
    valid?
  end

  # ----- Validations -----
  validates_format_of :site_role, :with => /Primary|Backup/
  validates_format_of :auto_sync, :with => /ON|OFF/
  validates_length_of :password,  :within => 4..12


  # ----- Callbacks -----

  define_model_callbacks :save

  before_save :reset_peer_url, :reset_auto_sync

  
  # ----- Instance Methods -----

  def primary?
    @site_role == "Primary"
  end

  def backup?
    @site_role == "Backup"
  end

  def peer_url_undefined?
    peer_url.empty? || peer_url == "NONE"
  end

  def peer_url_defined?
    ! peer_url_undefined?
  end

  def peer_csv
    peer_url_defined? ? peer_url + "/calendar.csv" : "NONE"
  end

  def peer_csv_link
    if peer_url_defined?
      "<a href='#{peer_csv}'>#{peer_csv}</a>"
    else
      "No Peer Selected"
    end
  end

  def peer_url_link
    if peer_url_defined?
      "<a href='#{@peer_url}'>#{@peer_url}</a>"
    else
      "No Peer Selected"
    end
  end

  def reset_peer_url
    @peer_url = "NONE" if @peer_url.nil? || @peer_url.empty?
  end

  def reset_auto_sync
    @auto_sync = "OFF" if primary? || peer_url_undefined?
  end

  def toggle_button_text
    auto_sync == "OFF" ? "Turn On" : "Turn Off"
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