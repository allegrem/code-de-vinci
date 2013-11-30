class JoueursPartiesPartieIdJoueurId < ActiveRecord::Migration
  def self.up
    add_column :joueurs_parties, :joueur_id, :integer
    add_column :joueurs_parties, :partie_id, :integer
  end

  def self.down
    remove_column :joueurs_parties, :joueur_id
    remove_column :joueurs_parties, :partie_id
  end
end
