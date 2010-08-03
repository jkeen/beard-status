class ChangeStatesToVersions < ActiveRecord::Migration
  def self.up
    rename_table :beard_states, :beard_versions
  end

  def self.down
    rename_table :beard_versions, :beard_states
  end
end
