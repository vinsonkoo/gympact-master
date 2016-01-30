class RemovePaymentColumnFromPaymentsTable < ActiveRecord::Migration
  def change
    remove_column :payments, :payment, :float
  end
end
