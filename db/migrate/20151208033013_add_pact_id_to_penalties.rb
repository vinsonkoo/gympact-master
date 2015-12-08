class AddPactIdToPenalties < ActiveRecord::Migration
  def change

    add_column :penalties, :pact_id, :integer
  end
end
