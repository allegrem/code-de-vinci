class ChangeNameUpdateIdPartie < ActiveRecord::Migration
  def self.up
		rename_column :parties, :update, :update_id
  end

  def self.down
		rename_column :parties, :update_id, :update
  end
end
