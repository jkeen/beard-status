class OldDude < ActiveRecord::Base
end

class MoveDudes < ActiveRecord::Migration
  def self.up
    # necessary since DataMapper didn't require me to create IDs for the 
    OldDude.all.each do |old_dude|
      d = Dude.create({:name => old_dude.name, :slug => old_dude.slug})
      BeardState.create(:dude_id => d.id, :status => old_dude.status)
    end
    
    drop_table :old_dudes
  end

  def self.down
    create_table :old_dudes, :force => true do |t|
      t.string :name
      t.string :slug
      t.boolean :status      
    end
    
    Dude.each do |dude|
      OldDude.create({:name => dude.name, :slug => dude.slug, :status => dude.beard_states.last.status})
    end
  end
end
