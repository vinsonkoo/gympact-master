class PactUserRelation < ActiveRecord::Base
  # validates :user_id, presence: true

	#######################################################
	# Specifies Associations
	# Read more about Rails Associations here: http://guides.rubyonrails.org/association_basics.html
	belongs_to :pact 
	belongs_to :user
  # accepts_nested_attributes_for :user, :pact
  # composed_of :users, mapping: [ %q(user_id) ]
  
	#######################################################
	# Makes it so that you can edit these database columns via ActiveAdmin and forms
  # attr_accessible :pact_id, :user_id
end
