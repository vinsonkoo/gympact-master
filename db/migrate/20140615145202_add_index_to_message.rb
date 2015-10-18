class AddIndexToMessage < ActiveRecord::Migration
  def change
  	add_index :messages, ["message", "pact_id"], :unique => true
  end
end
