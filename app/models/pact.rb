class Pact < ActiveRecord::Base

	#######################################################
	# Specifies Associations
	# Read more about Rails Associations here: http://guides.rubyonrails.org/association_basics.html
	has_many :users
	has_many :pact_user_relations

	has_many :chats

	has_many :penalties

	has_many :weeks

	#######################################################
	# Makes it so that when you print the "Pact" object, you print the pact_name instead of the "#<ActiveRecord>blahblah" object name
	alias_attribute :name, :pact_name

	#######################################################
  # deprecated in rails 4
	# Makes it so that you can edit these database columns via ActiveAdmin and forms
  # attr_accessible :end_date, :is_active, :pact_name, :start_date



	#######################################################
  # OBJECT ACTIONS
  # Actions you'd want to do on a Pact object
  # Example: The way you would use these would be if in your HTML file, you want to get a list of all the pact's users. You will write <%= pact.get_users %> which would return an array (list) of user objects.


  # Gets users who are in this pact
	def get_users
		User.joins(:pact_user_relations).where(pact_user_relations: { pact_id: self.id })
	end

	# Gets the week that the pact is on as of today
	def get_current_week
    today = Date.today
    week = Week.where(["pact_id = ? and start_date <= ? and end_date >= ?", self.id, today, today]).first
    if !week
      week = Week.where(["pact_id = ?", self.id]).last
    end
    week
  end


  # Get total stats for this pact
  def get_total_workout_days
  end

  def get_total_goal_days
  end

  def get_total_missed_days
  end

  def get_total_owed
  end

  # Get weekly stats for this pact
 	def get_week_workout_days(current_week)
 	end

 	def get_week_goal_days(current_week)
 	end

 	def get_week_missed_days(current_week)
 	end

	def get_week_bonus_days(current_week)
 	end

 	def get_week_money_owed(current_week)
 	end


end
