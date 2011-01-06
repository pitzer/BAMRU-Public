class Event < ActiveRecord::Base

  # ----- Validations -----
  validates_presence_of   :kind, :title, :location, :leaders, :start
  # validates_uniqueness_of :title

  # Other Validations TBD
  # end must be after start
  # start, end must be valid dates
  # kind can be one of %w(meeting training event non_county)

  # TODO: Calculate an event hash
  # TODO: The event hash must be unique

  # empty start date should report as TBA

  # ----- Local Methods -----
  # display_date

end
