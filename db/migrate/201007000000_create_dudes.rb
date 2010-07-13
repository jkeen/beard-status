class CreateDudes < ActiveRecord::Migration
  def self.up
    unless table_exists?(:dudes)
      create_table :dudes do |t|
        t.integer :id
        t.string :name
        t.string :slug
        t.boolean :status
      end
    end
  end

  def self.down
  end
end
