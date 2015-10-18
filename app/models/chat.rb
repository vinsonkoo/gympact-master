class Chat < ActiveRecord::Base
	#######################################################
	# Specifies Associations
	# Read more about Rails Associations here: http://guides.rubyonrails.org/association_basics.html
	has_many :messages
	has_many :users

	belongs_to :pact

	#######################################################
	# Makes it so that when you print the "Chat" object, you print the created_at date instead of the "#<ActiveRecord>blahblah" object name
	alias_attribute :name, :created_at 

	#######################################################
  # deprecated in rails 4
	# Makes it so that you can edit these database columns via ActiveAdmin and forms	
  # attr_accessible :chat, :pact_id
end
