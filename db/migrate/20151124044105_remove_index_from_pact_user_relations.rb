class RemoveIndexFromPactUserRelations < ActiveRecord::Migration
  def change
    remove_index(:pact_user_relations, :name => 'index_pact_user_relations_on_pact_id_and_user_id')
    remove_index(:pact_user_relations, :name => 'index_pact_id_5')
    remove_index(:pact_user_relations, :name => 'index_user_id_4')
  end
end
