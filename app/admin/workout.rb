ActiveAdmin.register Workout do
    permit_params [:distance, :pace, :duration, :video1, :video2, :workout_name, :workout_description, :is_makeup_workout, :user_id, :week_id, :sent, :pact_id, :message_id]

  form do |f|
    f.inputs "Workout" do
      f.input :distance
      f.input :pace
      f.input :duration
      f.input :video1
      f.input :video2
      f.input :workout_name
      f.input :workout_description
      f.check_box :is_makeup_workout
      f.input :user_id
      f.input :week_id
      f.input :sent
      f.input :pact_id
      f.input :message_id
    end
    f.actions
  end

	# index do
	# 	selectable_column
 #    column :id
 #    column :user
 #    column :week
 #    column :photo
 #    column :created_at
 #    column :updated_at
 #    actions
  # end
  
end
