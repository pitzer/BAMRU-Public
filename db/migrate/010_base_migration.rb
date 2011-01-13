class BaseMigration < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :digest
      t.string :kind,     :default => "event"
      t.string :title
      t.string :location, :default => "TBA"
      t.string :leaders,  :default => "TBA"
      t.date   :start,    :default => Time.now
      t.date   :finish
      t.text   :description
      t.boolean :first_in_year, :default => false
      t.timestamps
    end
  end
end
