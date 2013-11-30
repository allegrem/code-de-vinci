class AddUpToDateJoueursPartie < ActiveRecord::Migration
  def self.up
      add_column :joueurs_parties, :up_to_date, :boolean
  end

  def self.down
      remove_column :joueurs_parties, :up_to_date
  end
end
