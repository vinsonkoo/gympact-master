class AddWorkoutsRelationsToPactAndMessages < ActiveRecord::Migration
  def change

    create_table :pacts_workouts, :id => false do |t|
      t.integer :pact_id
      t.integer :workout_id
    end

    create_table :messages_workouts, :id => false do |t|
      t.integer :message_id
      t.integer :workout_id
    end

    drop_table :photos

    add_column :workouts, :pact_id, :integer
    remove_column :workouts, :photo_id, :integer

    add_column :messages, :workout_id, :integer
    remove_column :messages, :photo_url, :string
    remove_column :messages, :user, :string

  end
end
