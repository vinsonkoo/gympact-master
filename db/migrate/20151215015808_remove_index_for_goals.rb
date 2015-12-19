class RemoveIndexForGoals < ActiveRecord::Migration
  def change
    remove_index(:goals, :name => 'index_goals_on_pact_id_and_user_id_and_week_id')
  end
end
