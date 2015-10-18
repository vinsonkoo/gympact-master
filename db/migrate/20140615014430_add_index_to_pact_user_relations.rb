class AddIndexToPactUserRelations < ActiveRecord::Migration
  def change
  	add_index :pact_user_relations, ["pact_id", "user_id"], :unique => true
  end
end
