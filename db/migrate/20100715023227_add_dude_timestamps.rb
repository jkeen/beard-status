class AddDudeTimestamps < ActiveRecord::Migration
  def self.up
    change_table :dudes do |t|
      t.timestamps
    end
  end

  def self.down
    change_table :dudes do |t|
      t.remove :created_at
      t.remove :updated_at
    end
  end
end
