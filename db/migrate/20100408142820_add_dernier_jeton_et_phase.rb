class AddDernierJetonEtPhase < ActiveRecord::Migration
  def self.up
    add_column :joueurs_parties, :dernier_jeton, :string
    add_column :parties, :phase, :integer, :default => "0"
  end

  def self.down
    remove_column :joueurs_parties, :dernier_jeton
    remove_column :parties, :phase
  end
end
