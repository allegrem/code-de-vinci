class AddMessagePartie < ActiveRecord::Migration
  def self.up
    add_column :parties, :message, :string
  end

  def self.down
    remove_column :parties, :message
  end
end
