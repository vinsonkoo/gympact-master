class Photo < ActiveRecord::Base

	#######################################################
	# Specifies Associations
	# Read more about Rails Associations here: http://guides.rubyonrails.org/association_basics.html
	has_many :workouts
	belongs_to :message


	#######################################################
	# Makes it so that when you print the "Photo" object, you print the photo_url instead of the "#<ActiveRecord>blahblah" object name
  alias_attribute :name, :photo_url


	#######################################################
	# Makes it so that you can edit these database columns via ActiveAdmin and forms
  attr_accessible :notes, :photo_url, :message_id

end
