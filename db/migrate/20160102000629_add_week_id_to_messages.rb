class AddWeekIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :week_id, :integer
  end
end
