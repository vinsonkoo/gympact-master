class AddOwedAndPaidColumnsToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :owed, :float
    add_column :payments, :paid, :float
  end
end
