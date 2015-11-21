ActiveAdmin.register Message do
	index do
		selectable_column
    column :id
    column :pact
    column :msg_date_time
    column :date
    column :time
    column :sender
    column :message
    column :media
    column :image
    column :video
    column :created_at
    column :updated_at
    actions
  end
  
end
