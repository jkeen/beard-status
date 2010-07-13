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
  end
end
