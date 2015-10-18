class WorkoutType < ActiveRecord::Base

	#######################################################
	# Specifies Associations
	# Read more about Rails Associations here: http://guides.rubyonrails.org/association_basics.html
	belongs_to :workout

	# Makes it so that when you print the "WorkoutType" object, you print the workout_type instead of the "#<ActiveRecord>blahblah" object name
	alias_attribute :name, :workout_type
	
	#######################################################
	# deprecated in rails 4
	# Makes it so that you can edit these database columns via ActiveAdmin and forms
  # attr_accessible :workout_type, :workout_id
end
