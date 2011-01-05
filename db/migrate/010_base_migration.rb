class BaseMigration < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string   :kind
      t.string   :title
      t.string   :location
      t.string   :leaders
      t.date     :start
      t.date     :end
      t.text     :description
      t.timestamps
    end
  end
end
