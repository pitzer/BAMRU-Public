class BaseMigration < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :digest
      t.string :kind,     :default => "event"
      t.string :title
      t.string :location, :default => "TBA"
      t.string :leaders,  :default => "TBA"
      t.date   :start,    :default => Time.now
      t.date   :end
      t.text   :description
      t.timestamps
    end
  end
end
