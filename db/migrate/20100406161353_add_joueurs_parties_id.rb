class AddJoueursPartiesId < ActiveRecord::Migration
  def self.up
      add_column :joueurs_parties, :id, :integer, :primary_key => true
  end

  def self.down
      remove_column :joueurs_parties, :id
  end
end
