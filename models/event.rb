class Event < ActiveRecord::Base

  # ----- Validations -----
  # validates_presence_of   :kind, :title, :location, :leaders, :start
  # validates_uniqueness_of :title
  # validates_length_of     :title, :within => 3..20

  # Other Validations TBD
  # end must be after start
  # start, end must be valid dates
  # kind can be one of %w(meeting training event non_county_meeting)

  # default value of leader is TBA

  # empty start date should report as TBA

end
