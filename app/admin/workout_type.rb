ActiveAdmin.register WorkoutType do
	index do
		selectable_column
    column :id
    column :workout
    column :workout_type
    column :created_at
    column :updated_at
    actions
  end
end
