class CreateWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts do |t|
      t.float :distance
      t.string :pace
      t.string :duration
      t.string :video1
      t.string :video2
      t.string :workout_name
      t.text :workout_description
      t.boolean :is_makeup_workout

      t.timestamps
    end
  end
end
