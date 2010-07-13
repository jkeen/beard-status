class CreateDudes < ActiveRecord::Migration
  def self.up
    create_table :dudes do |t|
      t.integer :id
      t.string :name
      t.string :slug
      t.boolean :status
    end
  end

  def self.down
  end
end
