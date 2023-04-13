class CreateUserFollows < ActiveRecord::Migration[7.0]
  def change
    create_table :user_follows do |t|
      t.integer :follower_id, null: false
      t.integer :followee_id, null: false

      t.timestamps
    end
  end
end
