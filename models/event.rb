require 'time'

class Time
  def to_label() strftime "%b-%Y"; end
end

class Event < ActiveRecord::Base

  # ----- Callbacks -----
  before_validation :save_signature_into_digest_field
  before_validation :tbd_to_tba
  before_validation :cleanup_non_county
  before_save       :remove_quotes

  # ----- Validations -----
  validates_presence_of   :kind, :title, :location, :leaders, :start
  validates_uniqueness_of :digest, :message => "duplicate record - identical title, location, start"

  validates_format_of :kind, :with => /^(meeting|training|event|non-county)$/

  validate :check_dates

  # start must happen before end
  def check_dates
    return if self.end.nil? || self.end.blank?
    errors[:start] << "must happen before 'end'" if self.end < self.start
  end

  # ----- Dates & Scopes -----

  def self.date_parse(date) date.class == String ? Time.parse(date) : date; end
  def self.default_start()      2.months.ago; end
  def self.default_end()        10.months.from_now; end
  def self.first_event(); x = Event.order('start').first; x.start unless x.nil? ; end
  def self.last_event();  x = Event.order('start').last;  x.start unless x.nil? ;  end
  def self.first_year();  x = Event.first_event; x.at_beginning_of_year unless x.nil?; end
  def self.last_year();   x = Event.last_event;  x.at_end_of_year unless x.nil?; end
  def self.range_array(extra = nil)
    return nil if self.first_year.nil? || self.last_year.nil?
    xa = ((self.first_year + 10.days).to_date .. (self.last_year + 1.year).to_date).step(365).to_a.map{|x| x.to_time}
    xa << Event.date_parse(extra) unless extra.nil?
    xa.sort.map {|x| x.to_label }
  end
  
  def self.after(date); where('start >= ?', self.date_parse(date)); end
  def self.before(date); where('start <= ?', self.date_parse(date)); end
  def self.between(start, finish) after(start).before(finish); end

  scope :meetings,   where(:kind => "meeting").order('start')
  scope :events,     where(:kind => "event").order('start')
  scope :non_county, where(:kind => "non-county").order('start')
  scope :trainings,  where(:kind => "training").order('start')

  # ----- Local Methods -----

  def cleanup_non_county
    self.kind = 'non-county' if self.kind[0..5] == "non-co"
  end

  # Convert double quotes to single quotes.
  # This is done to support CSV output.
  # (CSV output fields are wrapped in double quotes.)
  def remove_quotes
    self.title.gsub!(%q["],%q['])       unless self.title.nil?
    self.location.gsub!(%q["],%q['])    unless self.location.nil?
    self.leaders.gsub!(%q["],%q['])     unless self.leaders.nil?
    self.description.gsub!(%q["],%q[']) unless self.description.nil?
  end

  # Changes 'tba, TBD, tbd' to 'TBA'
  # Changes nil or blank value to 'TBA'
  def tbd_to_tba
    self.location.gsub!(/[Tt][Bb][DdAa]/, "TBA")
    self.location = "TBA" if self.location.nil? || self.location.blank?
    self.leaders.gsub!(/[Tt][Bb][DdAa]/,  "TBA")
    self.leaders = "TBA" if self.leaders.nil? || self.leaders.blank?
  end

  def signature_fields
    "#{self.title}/#{self.location}/#{self.leaders}/#{self.start}/#{self.end}"
  end

  # The signature is a MD5 digest.
  def generate_signature
    Digest::MD5.hexdigest signature_fields
  end

  # The digest field is checked to ensure it is unique.
  # This eliminates the possibility of duplicate records.
  def save_signature_into_digest_field
    self.digest = generate_signature
  end

end
