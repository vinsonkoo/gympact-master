class RemoveTimeSentFromMessages < ActiveRecord::Migration
  def up
    remove_column :messages, :time_sent
  end

  def down
    add_column :messages, :time_sent, :time
  end
end
