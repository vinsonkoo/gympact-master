class AddPenaltiesToPact < ActiveRecord::Migration
  def change
    add_column :pacts, :penalty, :float
  end
end
