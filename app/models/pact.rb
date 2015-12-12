class Pact < ActiveRecord::Base
  require 'date'

  after_create :check_active, :parse_weeks
  # after_update :check_goals
	#######################################################
	# Specifies Associations
	# Read more about Rails Associations here: http://guides.rubyonrails.org/association_basics.html
	has_and_belongs_to_many :users
	
  has_many :goals
  accepts_nested_attributes_for :goals

	has_many :chats

	has_many :penalties, dependent: :destroy
  accepts_nested_attributes_for :penalties
  

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
	# def get_users
	# 	User.joins(:pact_user_relations).where(pact_user_relations: { pact_id: self.id })
	# end

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

  private

  def check_active
    @pact = Pact.last
    if (@pact.start_date..@pact.end_date).cover?(Date.today)
      @pact.is_active = true
      @pact.save
      # redirect_to @pact
    else
      @pact.is_active = false
      @pact.save
      # redirect_to @pact
    end
  end

  def parse_weeks
    @pact = Pact.last
    start_date  = @pact.start_date
    end_date = @pact.end_date
    date_range = start_date..end_date
    weeks = date_range.to_a.map(&:beginning_of_week).uniq
    if weeks[0] != start_date
      weeks.delete(weeks[0])
      # if start date is not on a monday, it will take the first monday before the start date and insert it into the weeks array. this is to delete that week since it does not fall into the start/end dates range
    end
    # weeks variable above checks for 'uniqueness' of weeks for every day in the date range and puts them in an array
    # for each week, create a new week with start and end dates
    n = 0
    weeks.each do |week|
      @week = Week.new
      @week.start_date = weeks[n] 
      # start date of week is the nth object in the weeks array
      @week.end_date = @week.start_date + 6
      @week.week_number = n + 1
      @week.pact_id = @pact.id
      @week.save
      n += 1
    end
  end

  # def check_goals

  # end

end
