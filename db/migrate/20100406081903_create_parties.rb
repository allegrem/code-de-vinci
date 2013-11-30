class CreateParties < ActiveRecord::Migration
  def self.up
    create_table :parties do |t|
      t.integer :nbre_joueur
      t.integer :tour
      t.string :pioche
      t.timestamps
    end
  end

  def self.down
    drop_table :parties
  end
end
