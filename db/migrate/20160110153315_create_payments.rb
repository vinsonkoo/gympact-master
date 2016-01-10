class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.float :payment
      t.integer :user_id
      t.integer :pact_id

      t.timestamps null: false
    end
  end
end
