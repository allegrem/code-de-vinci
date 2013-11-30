class PartiesAddNomCreateur < ActiveRecord::Migration
  def self.up
    add_column :parties, :nom, :string
    add_column :parties, :createur, :integer
  end

  def self.down
    remove_column :parties, :nom
    remove_column :parties, :createur
  end
end
