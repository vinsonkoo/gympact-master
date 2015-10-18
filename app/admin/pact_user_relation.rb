ActiveAdmin.register PactUserRelation do
	index do
    column :id
    column :pact
    column :user
    column :created_at
    column :updated_at
    actions
  end
  
end
