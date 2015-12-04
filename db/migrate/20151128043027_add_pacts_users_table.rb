class AddPactsUsersTable < ActiveRecord::Migration
  def change
    create_table :pacts_users, :id => false do |t|
      t.integer :pact_id
      t.integer :user_id
    end

    drop_table :pact_users
  end
end
