class PartiesTourParDefaut < ActiveRecord::Migration
  def self.up
    change_column :parties, :tour, :integer, :default => '-1'
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
