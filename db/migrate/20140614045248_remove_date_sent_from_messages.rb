class RemoveDateSentFromMessages < ActiveRecord::Migration
  def up
    remove_column :messages, :date_sent
  end

  def down
    add_column :messages, :date_sent, :date
  end
end
