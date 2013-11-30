class CreateJoueurs < ActiveRecord::Migration
  def self.up
    create_table :joueurs do |t|
      t.string :pseudo
      t.string :hashed_password
      t.string :salt
      t.timestamps
    end
  end

  def self.down
    drop_table :joueurs
  end
end
