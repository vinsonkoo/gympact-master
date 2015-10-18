class AddTimeSentToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :time, :time
    add_column :messages, :date, :date
  end
end
