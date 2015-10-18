class AddPactUserRelationAssociationToPact < ActiveRecord::Migration
  def self.up
    add_column :pact_user_relations, :pact_id, :integer
    add_index 'pact_user_relations', ['pact_id'], :name => 'index_pact_id_5' 
  end

  def self.down
    remove_column :pact_user_relations, :pact_id
  end
end
