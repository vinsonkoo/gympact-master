class ChangeUserIdInMessagesToNullTrue < ActiveRecord::Migration
  def change
    change_column :messages, :user_id, :integer, null: true
  end
end
