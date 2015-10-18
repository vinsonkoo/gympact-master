ActiveAdmin.register Message do
	index do
		selectable_column
    column :id
    column :pact
    column :user
    column :message
    column :photo_url
    column :created_at
    column :updated_at
    actions
  end
  
end
