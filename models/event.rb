class Event < ActiveRecord::Base

  # ----- Callbacks -----
  before_validation :set_digest

  # ----- Validations -----
  validates_presence_of   :kind, :title, :location, :leaders, :start
  validates_uniqueness_of :digest

  # Other Validations TBD
  # end must be after start
  # start, end must be valid dates
  # kind can be one of %w(meeting training event non_county)

  # TODO: Calculate an event hash
  # TODO: The event hash must be unique

  # empty start date should report as TBA

  # ----- Local Methods -----
  # display_date

  def identifying_fields
    "#{self.title}/#{self.location}/#{self.leaders}/#{self.start}/#{self.end}"
  end

  def calculate_digest
    Digest::MD5.hexdigest identifying_fields
  end

  def set_digest
    self.digest = calculate_digest
  end

end
