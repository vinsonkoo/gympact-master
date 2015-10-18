class RemoveTimeSentInSecondsFromMessages < ActiveRecord::Migration
  def up
    remove_column :messages, :time_sent_in_seconds
  end

  def down
    add_column :messages, :time_sent, :integer, :limit => 2
  end
end
