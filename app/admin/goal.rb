ActiveAdmin.register Goal do
    permit_params [:email, :password, :password_confirmation, :first_name, :last_name, :username]
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
