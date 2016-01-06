class RemovePactUserRelationsTable < ActiveRecord::Migration
  def change
    drop_table :pact_user_relations
  end
end
