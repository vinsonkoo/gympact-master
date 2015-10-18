class AddTimeSentInSecondsToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :time_sent_in_seconds, :integer, :limit => 2
  end
end
