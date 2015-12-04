class AddIndexForUserAndPactIdsToPactUserRelations < ActiveRecord::Migration
  def change
    add_index :pact_user_relations, :pact_id
    add_index :pact_user_relations, :user_id
    add_index :pact_user_relations, [:pact_id, :user_id], unique: true
  end
end
