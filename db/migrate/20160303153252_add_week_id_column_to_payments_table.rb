class AddWeekIdColumnToPaymentsTable < ActiveRecord::Migration
  def change
    add_column :payments, :week_id, :integer
  end
end
