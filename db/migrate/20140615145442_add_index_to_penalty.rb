class AddIndexToPenalty < ActiveRecord::Migration
  def change
  	add_index :penalties, ["pact_id", "goal"], :unique => true
  end
end
