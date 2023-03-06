class CreateTasks < ActiveRecord::Migration[6.1]
  def change
    create_table :tasks do |t|
      t.string :title, null: false
      t.string :description, null: false
      t.datetime :due
      t.datetime :created_at, null: false
      t.integer :user_id
    end
    
    add_foreign_key :tasks, :users
  end
end
