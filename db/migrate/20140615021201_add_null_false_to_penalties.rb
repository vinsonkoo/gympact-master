class AddNullFalseToPenalties < ActiveRecord::Migration
  def change
  	change_column :penalties, :goal, :integer, :default => 0, :null => false
  	change_column :penalties, :penalty, :float, :default => 0, :null => false
  end
end
