class Add < ActiveRecord::Migration
  def change
    add_column :messages, :week_number, :integer
  end
end
