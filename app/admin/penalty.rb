ActiveAdmin.register Penalty do
  index do
	selectable_column
    column :id
    column :pact
    column :goal_days
    column :penalty
    column :created_at
    column :updated_at
    actions
  end
  
end
