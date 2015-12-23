class Pact < ActiveRecord::Base
  require 'date'

  after_create :check_active, :parse_weeks
  after_save :check_goals
	#######################################################
	# Specifies Associations
	# Read more about Rails Associations here: http://guides.rubyonrails.org/association_basics.html
	has_and_belongs_to_many :users
	
  has_many :goals, dependent: :destroy
  accepts_nested_attributes_for :goals

	has_many :chats
  accepts_nested_attributes_for :chats
  has_many :messages, through: :chats
  accepts_nested_attributes_for :chats
  accepts_nested_attributes_for :messages

	has_many :penalties, dependent: :destroy
  accepts_nested_attributes_for :penalties
  

	has_many :weeks, dependent: :destroy

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
    @pact = Pact.find_by(id: id)
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
    # weeks variable above checks for 'uniqueness' of weeks for every day in the date range and puts them in an array
    if weeks[0] != start_date
      weeks.delete(weeks[0])
      # if start date is not on a monday, it will take the first monday before the start date and insert it into the weeks array. this is to delete that week since it does not fall into the start/end dates range
    elsif !date_range.cover?(weeks.last+6)
      weeks.pop
      # if last date and its week (monday - sunday) in the weeks array is not covered in the start/end dates range, delete it from the array
    end

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

  def check_goals
    @pact = Pact.find_by(id: id)

    if @pact.goals.count == (@pact.weeks.count) * (@pact.users.count)
      # break

    else
      if @pact.is_active?
        puts 'abcde'
        n = 1
        @pact.weeks.each do |pw|
          start_date = pw.start_date
          end_date = pw.end_date
          date_range = start_date..end_date
          today = Date.today
          # if start_date is in the future
          if start_date.future?
            total_weeks = @pact.weeks.count
            total_goals = @pact.goals.count
            if n < total_goals
              # for each goal, create new goals for user
              @pact.goals.each do |pg|            
                user = pg.user_id
                goal = pg.goal
                new_goal = @pact.goals.build
                new_goal.user_id = user
                new_goal.goal = goal
                new_goal.week_id = pw.id
                if (n + 1) < (@pact.weeks.count) * (@pact.users.count)
                  new_goal.save
                else
                  
                end
                # debugger
                n = n + 1
              end
            end
            # n = n + 1
          else
            # if the pact's week is not in the future, do nothing

          end # @pacts.weeks.each do |pw|
        end

      else
        puts 'hello'
        # if pact is not active, update all goals for all weeks for each user
        total_weeks = @pact.weeks.count
        n = 1
        total_goals = @pact.goals.count

        # check each initial goal
        @pact.goals.each do |pg|
          # there is an infinite loop due to this being checked every time
          if n < total_goals
            puts 'hello2'
            user = pg.user_id
            goal = pg.goal

            # for each week, create a new goal
            @pact.weeks.each do |pw|
              new_goal = @pact.goals.build
              new_goal.user_id = user
              new_goal.goal = goal
              new_goal.week_id = pw.id
              new_goal.save
            end
            n = n + 1
            puts n
          else
            puts 'bye'
          end

        end

      end

    end
    
  end # def check_goals

end
