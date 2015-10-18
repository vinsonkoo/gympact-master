ActiveAdmin.register Workout do
	index do
		selectable_column
    column :id
    column :user
    column :week
    column :photo
    column :created_at
    column :updated_at
    actions
  end
  
end
