class DropMessageIndex < ActiveRecord::Migration
  def up
  	remove_index(:messages, :name => 'index_messages_on_message_and_pact_id')
  end

  def down
  	add_index :messages, ["message", "pact_id"], :unique => true
  end
end
