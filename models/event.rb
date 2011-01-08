class Event < ActiveRecord::Base

  # ----- Callbacks -----
  before_validation :save_signature_into_digest_field
  before_save       :remove_quotes, :tbd_to_tba

  # ----- Validations -----
  validates_presence_of   :kind, :title, :location, :leaders, :start
  validates_uniqueness_of :digest     # no duplicate records allowed!

  # Other Validations TBD
  # end must be after start
  # start, end must be valid dates
  # kind can be one of %w(meeting training event non_county)

  # empty start date should report as TBA

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
  def tbd_to_tba
    self.location.gsub!(/[Tt][Bb][DdAa]/, "TBA")
    self.leaders.gsub!(/[Tt][Bb][DdAa]/,  "TBA")
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
