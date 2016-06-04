class CreatePactPhotos < ActiveRecord::Migration
  def change
    create_table :pact_photos do |t|
      t.string :photo
      t.integer :pact_id

      t.timestamps null: false
    end
  end
end
