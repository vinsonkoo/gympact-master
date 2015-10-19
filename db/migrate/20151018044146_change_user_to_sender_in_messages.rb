class ChangeUserToSenderInMessages < ActiveRecord::Migration
  def change
    remove_column :messages, :user, :string
    add_column :messages, :sender, :string
  end
end
