class ChangeTimeToString < ActiveRecord::Migration
  def change
    remove_column :messages, :time, :time
    add_column :messages, :time, :string
  end
end
