class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, char: 200, null: false, unique: true
      t.string :phone_number, char: 20, null: false, unique: true
      t.string :full_name, char: 200
      t.string :password_digest
      t.string :key, char: 100, null: false, unique: true
      t.string :account_key, char: 100, unique: true
      t.text :metadata, char: 2000

      t.timestamps
    end
  end
end
