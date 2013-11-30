class AddUpdatePartie < ActiveRecord::Migration
  def self.up
		add_column :parties, :update, :integer, :default => 1
		remove_column :joueurs_parties, :up_to_date
		remove_column :joueurs_parties, :last_chat_message
		remove_column :parties, :message
  end

  def self.down
		remove_column :parties, :update
		add_column :joueurs_parties, :up_to_date, :boolean
		add_column :joueurs_parties, :last_chat_message, :integer, :default => 0
		add_column :parties, :message, :string
  end
end
