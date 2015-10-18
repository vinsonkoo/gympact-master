class AddDateSentToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :date_sent, :datetime
  end
end
