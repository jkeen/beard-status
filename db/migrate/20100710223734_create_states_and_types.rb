class CreateStatesAndTypes < ActiveRecord::Migration
  def self.up
    rename_table :dudes, :old_dudes
    
    create_table :dudes do |t|
      # t.integer :id
      t.string :name
      t.string :slug
      t.timestamp :pro
    end
    
    create_table :beard_types do |t|
      # t.integer :id
      t.string :name
      t.string :description
    end
    
    create_table :beard_states do |t|
      # t.integer :id
      t.integer :dude_id
      t.boolean :status
      t.integer :beard_type_id
      t.timestamps      
    end
  end

  def self.down
    rename_table :old_dudes, :dudes
    drop_table :beard_types
    drop_table :beard_states
  end
end
