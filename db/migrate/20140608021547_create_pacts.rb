class CreatePacts < ActiveRecord::Migration
  def change
    create_table :pacts do |t|
      t.string :pact_name
      t.date :start_date
      t.date :end_date
      t.boolean :is_active

      t.timestamps
    end
  end
end
