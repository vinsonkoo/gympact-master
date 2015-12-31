class Workout < ActiveRecord::Base

	#######################################################
	# Specifies Associations
	# Read more about Rails Associations here: http://guides.rubyonrails.org/association_basics.html
	has_many :workout_types
	belongs_to :user
	belongs_to :photo

	# Makes it so that when you print the "Workout" object, you print the workout description instead of the "#<ActiveRecord>blahblah" object name
	alias_attribute :name, :workout_description

	#######################################################
	# deprecated in rails 4
	# Makes it so that you can edit these database columns via ActiveAdmin and forms
  # attr_accessible :distance, :duration, :is_makeup_workout, :pace, :video1, :video2, :workout_description, :workout_name, :sent, :photo_id, :user_id, :week_id
end
