class ChangeUserIdInMessagesToNullFalse < ActiveRecord::Migration
  def change
    change_column :messages, :user_id, :integer, null: false
  end
end
