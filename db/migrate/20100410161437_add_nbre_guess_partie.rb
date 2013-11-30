class AddNbreGuessPartie < ActiveRecord::Migration
  def self.up
    add_column :parties, :nbre_guess, :integer
  end

  def self.down
    remove_column :parties, :nbre_guess
  end
end
