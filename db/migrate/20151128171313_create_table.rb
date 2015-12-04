class CreateTable < ActiveRecord::Migration
  def change
    create_table :pacts_penalties, :id => false do |t|
      t.integer :pact_id
    end
  end
end
