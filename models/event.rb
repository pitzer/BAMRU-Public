require 'time'

class Time
  def to_label() strftime "%b-%Y"; end
end

class Event < ActiveRecord::Base

  # ----- Callbacks -----
  before_validation :save_signature_into_digest_field
  before_validation :tbd_to_tba
  before_validation :cleanup_non_county
  before_validation :check_for_identical_start_finish
  before_save       :remove_quotes
  after_destroy     :set_first_in_year_after_delete
  after_save        :set_first_in_year_after_save

  # ----- Validations -----
  validates_presence_of   :kind, :title, :location, :start
  validates_uniqueness_of :digest, :message => "duplicate record - identical title, location, start"

  validates_format_of :kind, :with => /^(meeting|training|event|non-county)$/

  validate :check_dates

  # start must happen before end
  def check_dates
    return if self.finish.nil? || self.finish.blank?
    errors[:start] << "must happen before 'end'" if self.finish < self.start
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
    xa.sort.map {|x| x.to_label }.uniq
  end
  
  def self.after(date); where('start >= ?', self.date_parse(date)); end
  def self.before(date); where('start <= ?', self.date_parse(date)); end
  def self.between(start, finish) after(start).before(finish); end

  scope :meetings,   where(:kind => "meeting").order('start')
  scope :events,     where(:kind => "event").order('start')
  scope :non_county, where(:kind => "non-county").order('start')
  scope :trainings,  where(:kind => "training").order('start')

  def self.in_year(date, kind)
    between(date.at_beginning_of_year, date.at_end_of_year).where(:kind => kind)
  end

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
    unless self.kind == 'meeting'
      self.leaders.gsub!(/[Tt][Bb][DdAa]/,  "TBA")
      self.leaders = "TBA" if self.leaders.nil? || self.leaders.blank?
    end
  end

  def check_for_identical_start_finish
    self.finish = nil if self.start == self.finish
  end

  def signature_fields
    "#{self.title}/#{self.location}/#{self.leaders}/#{self.start}/#{self.finish}"
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

  def date_display(show_year = false)
    year_string = first_in_year || show_year ? ", #{start.year}&nbsp;" : ""
    finish_string = finish ? "-#{finish.day}" : ""
    "#{start.strftime('%b')} #{start.day}#{finish_string}#{year_string}"
  end

  def set_first_in_year
    events = Event.in_year(start, kind).order('start').all
    events.first.update_attributes(:first_in_year => true) unless events.first.nil?
    events[1..-1].each {|x| x.update_attributes(:first_in_year => false)} unless events[1..-1].nil?
  end

  def set_first_in_year_after_delete
    return unless self.first_in_year == true
    set_first_in_year
  end

  def set_first_in_year_after_save
    return unless self.start_changed?
    set_first_in_year
  end

  def self.delete_all_records
    Event.all.each { |x| x.destroy }
  end

end
