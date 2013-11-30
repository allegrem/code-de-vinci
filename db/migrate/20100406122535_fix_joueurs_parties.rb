class FixJoueursParties < ActiveRecord::Migration
  def self.up
    remove_column :joueurs_parties, :id
    change_column :joueurs_parties, :en_jeu, :boolean, :default => "true"
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
