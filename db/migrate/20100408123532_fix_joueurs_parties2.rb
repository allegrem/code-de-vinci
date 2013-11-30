class FixJoueursParties2 < ActiveRecord::Migration
  def self.up
    drop_table :joueurs_parties
    create_table :joueurs_parties do |t|
      t.string :code
      t.boolean :en_jeu, :default => "true"
      t.integer :joueur_id
      t.integer :partie_id
      t.timestamps
    end
  end

  def self.down
  end
end
