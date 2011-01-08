class Event < ActiveRecord::Base

  # ----- Callbacks -----
  before_validation :save_signature_into_digest_field, :tbd_to_tba
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

  # ----- Local Methods -----

  # Convert double quotes to single quotes.
  # This is done to support CSV output.
  # (CSV output fields are wrapped in double quotes.)
  def remove_quotes
    self.title.gsub!(%q["],%q['])
    self.location.gsub!(%q["],%q['])
    self.leaders.gsub!(%q["],%q['])
    self.description.gsub!(%q["],%q['])
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
