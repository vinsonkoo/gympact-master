class AddWeekAssociationToUser < ActiveRecord::Migration
  def self.up
    add_column :weeks, :user_id, :integer
    add_index 'weeks', ['user_id'], :name => 'index_user_id_2' 
  end

  def self.down
    remove_column :weeks, :user_id
  end
end
