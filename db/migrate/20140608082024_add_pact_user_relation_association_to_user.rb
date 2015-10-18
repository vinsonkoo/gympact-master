class AddPactUserRelationAssociationToUser < ActiveRecord::Migration
  def self.up
    add_column :pact_user_relations, :user_id, :integer
    add_index 'pact_user_relations', ['user_id'], :name => 'index_user_id_4' 
  end

  def self.down
    remove_column :pact_user_relations, :user_id
  end
end
