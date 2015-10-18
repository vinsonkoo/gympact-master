class RemoveUserFromWeeks < ActiveRecord::Migration
  def up
    remove_column :weeks, :user_id
  end

  def down
    add_column :weeks, :user_id, :integer
  end
end
