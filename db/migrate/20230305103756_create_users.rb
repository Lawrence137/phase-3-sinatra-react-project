class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :full_name, null: false
      t.string :email, null: false, index: { unique: true }
      t.string :password_hash, null: false
      t.timestamps
    end
  end

end
