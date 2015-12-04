class ChangeUserIdToTextInPactUserRelations < ActiveRecord::Migration
  def change
    change_column :pact_user_relations, :user_id, :text
  end
end
