class CreatePactUserRelations < ActiveRecord::Migration
  def change
    create_table :pact_user_relations do |t|

      t.timestamps
    end
  end
end
