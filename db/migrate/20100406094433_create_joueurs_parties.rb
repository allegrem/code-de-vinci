class CreateJoueursParties < ActiveRecord::Migration
  def self.up
    create_table :joueurs_parties do |t|
      t.string :code
      t.boolean :en_jeu
      t.timestamps
    end
  end

  def self.down
    drop_table :joueurs_parties
  end
end
