class AddAttachmentToPacts < ActiveRecord::Migration
  def change
    add_column :pacts, :attachment, :string
  end
end
