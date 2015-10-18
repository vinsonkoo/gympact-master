class PactUserRelation < ActiveRecord::Base

	#######################################################
	# Specifies Associations
	# Read more about Rails Associations here: http://guides.rubyonrails.org/association_basics.html
	belongs_to :pact 
	belongs_to :user
  
	#######################################################
	# Makes it so that you can edit these database columns via ActiveAdmin and forms
  attr_accessible :pact_id, :user_id
end
