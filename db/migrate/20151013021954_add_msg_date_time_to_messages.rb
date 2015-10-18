class AddMsgDateTimeToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :msg_date_time, :string
  end
end
