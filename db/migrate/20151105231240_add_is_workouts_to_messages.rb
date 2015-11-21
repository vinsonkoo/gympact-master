class AddIsWorkoutsToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :is_workout, :boolean
  end
end
