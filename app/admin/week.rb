ActiveAdmin.register Week do
	index do
		selectable_column
    column :id
    column :pact
    column :week_number
    column :start_date
    column :end_date
    column :created_at
    column :updated_at
    actions
  end	
  
end
