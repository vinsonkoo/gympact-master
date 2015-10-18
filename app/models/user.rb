class User < ActiveRecord::Base

	#######################################################
	# Specifies Associations
	# Read more about Rails Associations here: http://guides.rubyonrails.org/association_basics.html
	has_many :pacts
	has_many :pact_user_relations

	has_many :messages
	has_many :photos

	has_many :weeks
	has_many :workouts	

	#######################################################
	# Makes sure email is unique, so that you don't add multiple users with the same email
	validates_uniqueness_of :email

	#######################################################
	# Makes it so that when you print the "User" object, you print the username instead of the "#<ActiveRecord>blahblah" object name
	alias_attribute :name, :username
	def to_s
  	"#{username}"
  end

	#######################################################
  # deprecated in rails 4
	# Makes it so that you can edit these database columns via ActiveAdmin and forms
  # attr_accessible :first_name, :username, :last_name, :avatar_url, :email


  #######################################################
  # OBJECT ACTIONS
  # Actions you'd want to do on a User object
  # Example: The way you would use these would be if in your HTML file, you want to know a user's total goal days. You will write <%= user.get_total_goal_days %> which would return "41".



  ######### Here are the actions to access a user's TOTAL stats across the specified pact
  def get_total_goal_days(current_pact)
  	Goal.where(user_id: self.id).where(pact_id: current_pact.id).sum(:goal)
 	end

 	def get_total_workout_days(current_pact)
 		# Remember you need to count DAYS of working out here, not total workouts
 	end

 	def get_total_bonus_days(current_pact)
 	end

 	def get_total_missed_days(current_pact)
 		if get_total_goal_days(current_pact) > self.workouts.count
 			get_total_goal_days(current_pact) - self.workouts.count 
 		else
 			0
 		end
 	end

 	def get_total_money_owed(current_pact)
 		# Gets tricky when user's goals have changed over the course of the pact...
 	end

 	########## Here are the actions to access a user's stats for the specified week
 	########## You don't need to specify "pact" here because the week objects specify pact
 	########## See associations in "models/week.rb"
 	def get_week_goal_days(current_week)
 	end

 	def get_week_workout_days(current_week)
 	end

 	def get_week_missed_days(current_week)
 	end

	def get_week_bonus_days(current_week)
 	end

 	def get_week_money_owed(current_week)
 	end
 	

 	########## Here are the actions to access a user's stats for the specified day of the week

 	# Checks if user worked out on the day_of_week during the current_week 
 	def get_worked_out(current_week, day_of_week)
 		# return true or false
 	end



end
