class AddIndexToPact < ActiveRecord::Migration
  def change
  	add_index :pacts, ["pact_name"], :unique => true
  end
end
