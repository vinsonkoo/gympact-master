class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :message
      t.date :date_sent
      t.time :time_sent

      t.timestamps
    end
  end
end
