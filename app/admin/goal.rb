ActiveAdmin.register Goal do
	index do
		selectable_column
    column :id
    column :pact
    column :user
    column :goal
    column :created_at
    column :updated_at
    actions
  end

end
