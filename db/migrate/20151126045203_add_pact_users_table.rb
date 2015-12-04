class AddPactUsersTable < ActiveRecord::Migration
  def change
    create_table :pact_users, :id => false do |t|
      t.integer :pact_id
      t.integer :user_id
    end
  end
end
