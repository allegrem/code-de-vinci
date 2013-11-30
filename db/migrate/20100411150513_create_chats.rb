class CreateChats < ActiveRecord::Migration
  def self.up
    create_table :chats do |t|
			t.string :message
			t.integer :partie_id
      t.timestamps
    end
		
		add_column :joueurs_parties, :last_chat_message, :integer, :default => 0
  end

  def self.down
    drop_table :chats
		remove_column :joueurs_parties, :last_chat_message
  end
end
