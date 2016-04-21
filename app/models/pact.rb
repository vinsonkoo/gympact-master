class Pact < ActiveRecord::Base
  require 'date'

  after_create  :check_active, :parse_weeks
  after_update  :create_payments
  after_save    :check_goals
  #######################################################
  # Specifies Associations
  # Read more about Rails Associations here: http://guides.rubyonrails.org/association_basics.html
  has_and_belongs_to_many :users
  
  has_many :goals, dependent: :destroy
  accepts_nested_attributes_for :goals

  has_many :messages
  accepts_nested_attributes_for :messages

  has_many :penalties, dependent: :destroy
  accepts_nested_attributes_for :penalties

  has_many :weeks, dependent: :destroy

  has_many :workouts, dependent: :destroy
  accepts_nested_attributes_for :workouts

  has_many :payments, dependent: :destroy
  accepts_nested_attributes_for :payments

  # mount_uploader :attachment, AttachmentUploader
  has_many :attachments
  accepts_nested_attributes_for :attachments



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



  # Gets the week that the pact is on as of today
  def get_current_week
    @pact = Pact.find_by(id: id)
    today = Date.today
    week = @pact.weeks.where(["end_date >= ?", today]).order(:week_number).first
    week_range = week.start_date..week.end_date
    # if week is before pact start_date, then week should be the first week
    if today <= @pact.start_date
      week = @pact.weeks.first
    # if week is after pact end_date, then week should be the last week
    elsif today >= @pact.end_date
      week = @pact.weeks.last
    else
      if week_range.cover?(today)
        week
      end
    end
    # @pact.weeks already includes the search for pact_id in the below statement
    # week = Week.where(["pact_id = ? and start_date <= ? or end_date >= ?", self.id, today, today]).first
    # if !week
    #   week = Week.where(["pact_id = ?", self.id]).last
    # end
    week
  end

  def penalty_for_goal(week_id, user)
    # get the pact's week based on week number
    # week = self.weeks.find_by(week_number: week_number)
    if self.penalties.empty?
    else
      if  user.goals.find_by( week_id: week_id ) == nil
      else
        self.penalties.find_by( goal_days: ( user.goals.find_by( week_id: week_id ).goal_days ) )
      end
    end
  end

  def get_bonus_days_for_week(week_number, user)
    # get the pact's week based on week number
    week = self.weeks.find_by(week_number: week_number)

    week_goal_days = 0
    week_workouts = 0
    week_missed_days = 0
    week_bonus_days = 0
    total_missed_days_at_beginning_of_week = 0
    total_missed_days_at_end_of_week = 0
    bonus_days_that_count = 0
    if self.goals.empty?
    else
      for i in 1 .. week_number 
        # get user's goal days for the week for the pact
        week_goal_days = user.goals.find_by("pact_id = ? and week_id = ?", self, week.id).goal_days
        # get user's workout count for the week
        week_workouts = user.workouts.where("pact_id = ? and week_id = ?", self, week.id).count
        # if you have bonus days
        if week_workouts > week_goal_days 
          week_missed_days = 0
          week_bonus_days = week_workouts - week_goal_days
          if total_missed_days_at_beginning_of_week < week_bonus_days
            bonus_days_that_count = total_missed_days_at_beginning_of_week
          else
            bonus_days_that_count = week_bonus_days
          end
          # if you have missed days to be made up
          if total_missed_days_at_beginning_of_week > 0
            total_missed_days_at_end_of_week = total_missed_days_at_beginning_of_week - week_bonus_days
            # weekly_penalty = (total_penalty_at_beginning_of_week / total_missed_days_at_beginning_of_week) * bonus_days_that_count
          end
        # if you don’t have bonus days
        else
          week_bonus_days = 0
          week_missed_days = week_goal_days - week_workouts
          total_missed_days_at_end_of_week = total_missed_days_at_beginning_of_week + week_missed_days
        end
      end
        week_bonus_days
    end
  end

  def get_missed_days_beginning_of_week(week_number, user)
    # get the pact's week based on week number
    week = self.weeks.find_by(week_number: week_number)

    week_goal_days = 0
    week_workouts = 0
    week_missed_days = 0
    week_bonus_days = 0
    total_missed_days_at_beginning_of_week = 0
    total_missed_days_at_end_of_week = 0
    bonus_days_that_count = 0
    if self.goals.empty?
    else
      # to figure out if total_missed_days at beginning of week i > 0
      for i in 1 .. week_number 
        # get user's goal days for the week for the pact
        week_goal_days = user.goals.find_by("pact_id = ? and week_id = ?", self, week.id).goal_days
        # get user's workout count for the week
        week_workouts = user.workouts.where("pact_id = ? and week_id = ?", self, week.id).count
        total_missed_days_at_beginning_of_week = total_missed_days_at_end_of_week
        # if you have bonus days
        if week_workouts > week_goal_days 
          week_missed_days = 0
          week_bonus_days = week_workouts - week_goal_days
          if total_missed_days_at_beginning_of_week < week_bonus_days
            bonus_days_that_count = total_missed_days_at_beginning_of_week
          else
            bonus_days_that_count = week_bonus_days
          end
          # if you have missed days to be made up
          if total_missed_days_at_beginning_of_week > 0
            total_missed_days_at_end_of_week = total_missed_days_at_beginning_of_week - week_bonus_days
            # weekly_penalty = (total_penalty_at_beginning_of_week / total_missed_days_at_beginning_of_week) * bonus_days_that_count
          end
        # if you don’t have bonus days
        else
          week_bonus_days = 0
          week_missed_days = week_goal_days - week_workouts
          total_missed_days_at_end_of_week = total_missed_days_at_beginning_of_week + week_missed_days
        end
      end 

      # if it is week 1, total missed days at beginning of week is 0
      if i == 1
        total_missed_days_at_beginning_of_week = 0
        total_missed_days_at_beginning_of_week
      else
        total_missed_days_at_beginning_of_week
      end
      total_missed_days_at_beginning_of_week
    end
  end

  def get_missed_days_end_of_week(week_number, user)
    # get the pact's week based on week number
    week = self.weeks.find_by(week_number: week_number)

    week_goal_days = 0
    week_workouts = 0
    week_missed_days = 0
    week_bonus_days = 0
    total_missed_days_at_beginning_of_week = 0
    total_missed_days_at_end_of_week = 0
    bonus_days_that_count = 0
    if self.goals.empty?
    else
      # to figure out if total_missed_days at beginning of week i > 0
      for i in 1 .. week_number 
        # get user's goal days for the week for the pact
        week_goal_days = user.goals.find_by("pact_id = ? and week_id = ?", self, week.id).goal_days
        # get user's workout count for the week
        week_workouts = user.workouts.where("pact_id = ? and week_id = ?", self, week.id).count
        total_missed_days_at_beginning_of_week = total_missed_days_at_end_of_week
        # if you have bonus days
        if week_workouts > week_goal_days 
          week_missed_days = 0
          week_bonus_days = week_workouts - week_goal_days
          if total_missed_days_at_beginning_of_week < week_bonus_days
            bonus_days_that_count = total_missed_days_at_beginning_of_week
          else
            bonus_days_that_count = week_bonus_days
          end
          # if you have missed days to be made up
          if total_missed_days_at_beginning_of_week > 0
            total_missed_days_at_end_of_week = total_missed_days_at_beginning_of_week - week_bonus_days
          end
        # if you don’t have bonus days
        else
          week_bonus_days = 0
          week_missed_days = week_goal_days - week_workouts
          total_missed_days_at_end_of_week = total_missed_days_at_beginning_of_week + week_missed_days
        end
      end 
    end
    total_missed_days_at_end_of_week
  end

# original business logic
  def get_user_penalty_end_of_week(week_number, user)
    # get the pact's week based on week number
    week = self.weeks.find_by(week_number: week_number)

    week_goal_days = 0
    week_workouts = 0
    week_missed_days = 0
    week_bonus_days = 0
    total_missed_days_at_beginning_of_week = 0
    total_missed_days_at_end_of_week = 0
    bonus_days_that_count = 0
    total_penalty_at_beginning_of_week = 0
    total_penalty_at_end_of_week = 0
    if self.goals.empty?
    else
      # to figure out if total_missed_days at beginning of week i > 0
      for i in 1 .. week_number 
        if week_number > weeks.last.week_number
        else
          # get user's goal days for the week for the pact
          week_goal_days = user.goals.find_by("pact_id = ? and week_id = ?", self, week.id).goal_days
          # get user's workout count for the week
          week_workouts = user.workouts.where("pact_id = ? and week_id = ?", self, week.id).count
          total_missed_days_at_beginning_of_week = total_missed_days_at_end_of_week
          # get penalty for goal days
          penalty = penalty_for_goal(week.id, user)
          # if you have bonus days
          if week_workouts > week_goal_days 
            week_missed_days = 0
            week_bonus_days = week_workouts - week_goal_days
            if total_missed_days_at_beginning_of_week < week_bonus_days
              bonus_days_that_count = total_missed_days_at_beginning_of_week
            else
              bonus_days_that_count = week_bonus_days
            end
            # if you have missed days to be made up
            if total_missed_days_at_beginning_of_week > 0
              total_missed_days_at_end_of_week = total_missed_days_at_beginning_of_week - week_bonus_days
              weekly_penalty = (total_penalty_at_beginning_of_week / total_missed_days_at_beginning_of_week) * bonus_days_that_count
            end
          # if you don’t have bonus days
          else
            week_bonus_days = 0
            week_missed_days = week_goal_days - week_workouts
            total_missed_days_at_end_of_week = total_missed_days_at_beginning_of_week + week_missed_days
            total_penalty_at_end_of_week = total_penalty_at_beginning_of_week + (week_missed_days * penalty.penalty)
            total_penalty_at_beginning_of_week = total_penalty_at_end_of_week
          end
        end 
      end
    end
    @payment = payments.find_by(user_id: user.id)
    if @payment.paid == nil
      @payment.owed = total_penalty_at_end_of_week
    else
      @payment.owed = total_penalty_at_end_of_week - @payment.paid
    end
    @payment.save
    total_penalty_at_end_of_week
  end

  def get_user_penalty_for_week(week_number, user)
    # get the pact's week based on week number
    week = self.weeks.find_by(week_number: week_number)

    # get user's goal days for the week for the pact
    week_goal_days = user.goals.find_by("pact_id = ? and week_id = ?", self, week.id).goal_days
    # get user's workout count for the week
    week_workouts = user.workouts.where("pact_id = ? and week_id = ?", self, week.id).count

    # get penalty for goal days
    penalty = penalty_for_goal(week.id, user)
    if week_workouts > week_goal_days 
      penalty_for_week = 0
    else
      penalty_for_week = ( week_goal_days - week_workouts ) * penalty.penalty
    end
    # get payment for user
    @payment = payments.find_by(user_id: user.id)
    @payment.owed = penalty_for_week
    @payment.save
    penalty_for_week
  end

  def get_total_bonus_days_for_week(week_number)
    # get the pact's week based on week number
    week = self.weeks.find_by(week_number: week_number)

    total_week_goal_days = 0
    total_week_workouts = 0
    total_week_missed_days = 0
    total_week_bonus_days = 0
    total_missed_days_at_beginning_of_week = 0
    total_missed_days_at_end_of_week = 0
    total_bonus_days_that_count = 0
    if self.goals.empty?
    else
      for i in 1 .. week_number 

        # get total users' goal days for the week for the pact
        total_week_goal_days = ( @pact.goals.where(:week_id => week.id).sum :goal_days )
        # get total user's workout count for the week
        total_week_workouts = ( @pact.workouts.where(:week_id => week.id).count )

        # if there are bonus days
        if total_week_workouts > total_week_goal_days 
          total_week_missed_days = 0
          total_week_bonus_days = total_week_workouts - total_week_goal_days
          if total_missed_days_at_beginning_of_week < week_bonus_days
            total_bonus_days_that_count = total_missed_days_at_beginning_of_week
          else
            total_bonus_days_that_count = total_week_bonus_days
          end
          # if you have missed days to be made up
          if total_missed_days_at_beginning_of_week > 0
            total_missed_days_at_end_of_week = total_missed_days_at_beginning_of_week - total_week_bonus_days
            # weekly_penalty = (total_penalty_at_beginning_of_week / total_missed_days_at_beginning_of_week) * total_bonus_days_that_count
          end
        # if you don’t have bonus days
        else
          total_week_bonus_days = 0
          total_week_missed_days = total_week_goal_days - total_week_workouts
          total_missed_days_at_end_of_week = total_missed_days_at_beginning_of_week + total_week_missed_days
        end
      end
        total_week_bonus_days
    end
  end

  def get_total_penalty_for_week(week_number)
    # debugger
    # get the pact's week based on week number
    week = self.weeks.find_by(week_number: week_number)

    week_goal_days = 0
    week_workouts = 0
    week_missed_days = 0
    week_bonus_days = 0
    total_missed_days_at_beginning_of_week = 0
    total_missed_days_at_end_of_week = 0
    total_bonus_days_that_count = 0
    total_penalty_at_beginning_of_week = 0
    total_penalty_at_end_of_week = 0
    if self.goals.empty?
    else
      # to figure out if total_missed_days at beginning of week i > 0
      for i in 1 .. week_number 
        if week_number > weeks.last.week_number
        else

          # get total users' goal days for the week for the pact
          total_week_goal_days = ( @pact.goals.where(:week_id => week.id).sum :goal_days )
          # get total user's workout count for the week
          total_week_workouts = ( @pact.workouts.where(:week_id => week.id).count )
          total_missed_days_at_beginning_of_week = total_missed_days_at_end_of_week

          # debugger
          @pact.users.each do |user|
            # get penalty for goal days
            penalty = penalty_for_goal(week.id, user)
            # if you have bonus days
            if week_workouts > week_goal_days 
              week_missed_days = 0
              week_bonus_days = week_workouts - week_goal_days
              if total_missed_days_at_beginning_of_week < week_bonus_days
                total_bonus_days_that_count = total_missed_days_at_beginning_of_week
              else
                total_bonus_days_that_count = week_bonus_days
              end
              # if you have missed days to be made up
              if total_missed_days_at_beginning_of_week > 0
                total_missed_days_at_end_of_week = total_missed_days_at_beginning_of_week - week_bonus_days
                weekly_penalty = (total_penalty_at_beginning_of_week / total_missed_days_at_beginning_of_week) * total_bonus_days_that_count
              end
            # if you don’t have bonus days
            else
              week_bonus_days = 0
              week_missed_days = week_goal_days - week_workouts
              total_missed_days_at_end_of_week = total_missed_days_at_beginning_of_week + week_missed_days
              total_penalty_at_end_of_week = total_penalty_at_beginning_of_week + (week_missed_days * penalty.penalty)
              total_penalty_at_beginning_of_week = total_penalty_at_end_of_week
            end
          end
        end 
      end
    end
    total_penalty_at_end_of_week
    total_penalty_for_week = 1


  end

  # Get total stats for this pact
  def get_total_workout_days(week_number)
  end

  def get_total_goal_days
  end

  def get_total_missed_days(week_number)
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
    # @pact = Pact.last because this is done immediately after a pact is created
    @pact = Pact.last
    if (@pact.start_date..@pact.end_date).cover?(Date.today)
      @pact.is_active = true
      @pact.save
    else
      @pact.is_active = false
      @pact.save
    end
  end

  def parse_weeks
    # @pact = Pact.last because this is done immediately after a pact is created
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
      # if total goal count for the pact is equal to weeks * users, then update goals for weeks after current week
    if @pact.goals.empty?
    else
      current_week = @pact.get_current_week
      if @pact.goals.count == (@pact.weeks.count) * (@pact.users.count)
        @pact.weeks.each do |pw|
          # if pact week is after current_week's start date, then update the goals for the following weeks
          if pw.start_date >= current_week.start_date
            @pact.users.each do |pu|
              # get most recently updated goal for user for this pact
              last_goal = pu.goals.where(pact_id: @pact.id).last

              if last_goal == nil

              else
                # update goals for user for every week after current week
                pu.goals.each do |pg|
                  # if goal's week is before most recently updated goal, do not update it
                  if pg.week_id <= last_goal.week_id
                  else
                    # update the goal to match most recently updated goal
                    pg = last_goal
                    pg.save
                  end
                end
              end
            end
          end
        end
      else
        if @pact.is_active?
          @pact.weeks.each do |pw|
            # if pw.start_date.future?
              @pact.users.each do |pu|
                # get last updated goal for user for this pact
                last_goal = pu.goals.where(pact_id: @pact.id).last
                if last_goal == nil
                else
                  # if goal already exists for the week, do not create any new goals for that week
                  if @pact.goals.where(:week_id => pw.id, :user_id => pu.id).exists?
                    # last_goal.save
                  else
                    new_goal = @pact.goals.build
                    new_goal.user_id = pu.id
                    new_goal.goal_days = last_goal.goal_days
                    new_goal.week_id = pw.id
                    new_goal.save
                  end
                end
              end
          end
        else # if pact isn't active
          # this works

            @pact.weeks.each do |pw|
              @pact.users.each do |pu|
                # get last updated goal for user
                last_goal = pu.goals.where(pact_id: @pact.id).last
                if last_goal == nil

                else
                  # if goal already exists for the week, do not create any new goals for that week (if array is not empty)
                  if @pact.goals.where(:week_id => pw.id, :user_id => pu.id) != []
                  else
                    new_goal = @pact.goals.build
                    new_goal.user_id = pu.id
                    new_goal.goal_days = last_goal
                    new_goal.week_id = pw.id
                    new_goal.save
                  end

                  # ignore first week, since first week will have been created from the initial form
                  if pw == @pact.weeks.first 
                    # do nothing
                  else
                    @pact.users.each do |pu|
                    # get last updated goal for user
                    last_goal = pu.goals.last.goal_days
                    
                      # if goal already exists for the week, do not create any new goals for that week
                      if @pact.goals.where(:week_id => pw.id, :user_id => pu.id).exists?
                      else
                        new_goal = @pact.goals.build
                        new_goal.user_id = pu.id
                        new_goal.goal_days = last_goal
                        new_goal.week_id = pw.id
                        new_goal.save
                      end
                    end
                  end # if pw == @pact.weeks.first
                end # if last_goal == nil
              end
            end
          # end

        end # if pact.is_active?

      end # end of @pact.goals.count == (@pact.weeks.count) * (@pact.users.count)

    end # end if @pact.goals.empty?
    
  end # def check_goals


  def create_payments
    # @pact = Pact.last because this is done after users are added to a pact (after users are "updated" to the pact)
    @pact = Pact.find_by(id: id)
    @pact.users.each do |pu|
      @pact.weeks.each do |pw|
        # if payment for user is nil, create it
        # total payment objects should not exceed number of users
        if @pact.payments.where("user_id = ? and week_id = ?", pu.id, pw.id).empty?
          @payment = @pact.payments.build
          @payment.owed = 0
          @payment.paid = 0
          @payment.user_id = pu.id
          @payment.week_id = pw.id
          @payment.pact_id = @pact.id
          @payment.save
        end
      end
    end
  end
  

  def self.import(file, pact) 
    # open the file
    message_file = File.open(file.path, "r")
    # begin reading each line
    message_file.each_line { |line|

      @message = Message.new
      # separate date/time from the rest of the message (sender, message)
      @message.msg_date_time, sep, @message.message = line.partition(": ")
      # separate sender/user and message
      @message.sender, sep, @message.message = @message.message.partition(": ")
      # if fields are not blank, save. logic to check if any fields are blank before saving. date and time will most likely never be blank due to the constant format unlike users and messages, but will be checked anyway.
############################################################
      if @message.date != "" && @message.time != "" && @message.sender != "" && @message.message != "" 
        @message.date = Date.parse(@message.msg_date_time)
        @message.time = @message.msg_date_time.partition(", ")[2]
        

        # if @message.message.include? "<attached>"
        #   debugger
        # end
        # for some reason, below logic for parsing messages with media do not work without the above lines, even though it is commented out
        # logic that checks if message contains either an image or video, and if so media is set to true (boolean) and the other is set to nil in order to render the media in the view with an if statement

        if @message.message.include? ".jpg <‎attached>"
          # debugger
          @message.image = @message.message.partition(".jpg")[0]
          @message.media = true
          @message.video = nil
          @message.is_workout = true
        elsif @message.message.include? ".mp4 <attached>"
          # debugger
          @message.video = @message.message.partition(".mp4")[0]
          @message.media = true
          @message.image = nil
          @message.is_workout = true
        else
          @message.media = false
          @message.image = nil
          @message.video = nil
          @message.is_workout = false
          @message.workout_id = nil
          puts 'no media'
        end

        ####### USER LOGIC #######
        # check if a user's first and last name exists in database, if it doesn't exist, end chat upload and redirect to create user. ignore "System Message"

        # partition user's first and last name to find in database
        # first_name, sep, last_name = @message.sender.partition(" ")

        if User.find_by( username: @message.sender ).present?
          # true
          # do nothing and continue chat upload
          @message.user_id = User.find_by( username: @message.sender).id
        else
          # false
          # throw error and notice telling user to create users
          # raise "Error Message"
          # return false
          @message.user_id = nil
        end

        ####### USER LOGIC #######

        # if matching attributes do not exist in db, create
        if pact.weeks.where("start_date <= ? and end_date >= ?", @message.date, @message.date).empty?
          Message.find_or_create_by(
            :pact_id => pact.id,
            :msg_date_time => @message.msg_date_time,
            :date => @message.date,
            :time => @message.time,
            :sender => @message.sender,
            :message => @message.message,
            :media => @message.media,
            :image => @message.image,
            :video => @message.video,
            :user_id => @message.user_id,
            :is_workout => @message.is_workout,
            # message does not fall within pact's start and end dates, so week_id for the message should be nil
            :week_id => nil,
            # this attribute needs to be updated following the workout creation
            :workout_id => @message.workout_id
          )
        else
        Message.find_or_create_by(
          :pact_id => pact.id,
          :msg_date_time => @message.msg_date_time,
          :date => @message.date,
          :time => @message.time,
          :sender => @message.sender,
          :message => @message.message,
          :media => @message.media,
          :image => @message.image,
          :video => @message.video,
          :user_id => @message.user_id,
          :is_workout => @message.is_workout,
          # write a check for if a message is not within a week's start and end date, disregard it
          :week_id => pact.weeks.where("start_date <= ? and end_date >= ?", @message.date, @message.date).first.id,
          # this attribute needs to be updated following the workout creation
          :workout_id => @message.workout_id
        )
        end


        # if message contains media, create a new workout. cannot be placed in logic above that searches for media because the message hasn't been created/saved yet, so there is no corresponding @message.id
        if pact.weeks.where("start_date <= ? and end_date >= ?", @message.date, @message.date).empty?
        else
          if @message.message.include? ".jpg <attached>" 
            if @message.is_workout == true
              new_workout = pact.workouts.build(
                :distance => nil,
                :pace => nil,
                :duration => nil,
                :video1 => nil,
                :video2 => nil,
                :workout_name => nil,
                :workout_description => nil,
                :is_makeup_workout => nil,
                # find user based on @message.sender
                :user_id => @message.user_id,
                :week_id => pact.weeks.where("start_date <= ? and end_date >= ?", @message.date, @message.date).first.id,
                :pact_id => pact.id,
                :message_id => Message.find_by("message like? and msg_date_time like ?", @message.message, @message.msg_date_time).id
              )
              new_workout.save
            end
          elsif @message.message.include? ".mp4 <attached>"
            if @message.is_workout == true
              new_workout = pact.workouts.build(
                :distance => nil,
                :pace => nil,
                :duration => nil,
                :video1 => nil,
                :video2 => nil,
                :workout_name => nil,
                :workout_description => nil,
                :is_makeup_workout => nil,
                # find user based on @message.sender
                :user_id => @message.user_id,
                :week_id => pact.weeks.where("start_date <= ? and end_date >= ?", @message.date, @message.date).first.id,
                :pact_id => pact.id,
                :message_id => Message.find_by("message like? and msg_date_time like ?", @message.message, @message.msg_date_time).id
              )
              new_workout.save
            end
          end
        end
        

        # check if @message.time exists more than once, if @message.date exists more than once, and if @message.message is "<message omitted>"
        # if all true, delete @message because it's a duplicate media message that no longer has the image/video
        if Message.where(time: @message.time).count != 1 && Message.where(date: @message.date).count != 1 && @message.message == "<image omitted>"
          # Message.last == Message.where(message: Message.last.message) returns false
          @message.delete
        end
        if Message.where(time: @message.time).count != 1 && Message.where(date: @message.date).count != 1 && @message.message == "<video omitted>"
          # Message.last == Message.where(message: Message.last.message) returns false
          @message.delete
        end


############################################################
      elsif @message.date != "" && @message.time != "" && @message.sender != "" && @message.message = ""
        # if message is blank, it's a SYSTEM MESSAGE
        @message.date, sep, @message.time = @message.msg_date_time.partition(", ")
        # the following strptime line is no longer needed after using gem 'american_date'
        # @message.date = Date.strptime(@message.msg_date_time, "%m/%d/%y")
        @message.date = Date.parse(@message.msg_date_time)
        @message.time = @message.msg_date_time.partition(", ")[2]
        # @message.date = Date.strptime(@message.msg_date_time, "%m/%d/%y")
        @message.is_workout = false
        
        
        if pact.weeks.where("start_date <= ? and end_date >= ?", @message.date, @message.date).empty?
          Message.find_or_create_by(
          :pact_id => pact.id,
          :msg_date_time => @message.msg_date_time,
          :date => @message.date,
          :time => @message.time,
          # in system messages, the message is in the @message.sender field, so put that as @message.message
          :message => @message.sender,
          # @message.sender is system message
          :sender => "System Message",
          :media => @message.media, # nil
          :image => @message.image, # nil
          :video => @message.video, # nil
          # system message's user_id = nil
          :user_id => nil,
          :is_workout => @message.is_workout, # false
          # message is not within pact's start/end dates so week_id = nil
          :week_id => nil,
          # message is not within pact's start/end dates so week_id i= nil
          :workout_id => nil
        )
        else
        # find in db the following attributes, if they do not exist, create the db entry. @message.sender is the "system message", so replace @message.sender with @message.message and change @message.sender to "System Message"
        Message.find_or_create_by(
          :pact_id => pact.id,
          :msg_date_time => @message.msg_date_time,
          :date => @message.date,
          :time => @message.time,
          :message => @message.sender,
          :sender => "System Message",
          :media => @message.media, # nil
          :image => @message.image, # nil
          :video => @message.video, # nil
          # system message's user_id = nil
          :user_id => nil,
          :is_workout => @message.is_workout, # false
          # find corresponding week within pact's start/end dates
          :week_id => pact.weeks.where("start_date <= ? and end_date >= ?", @message.date, @message.date).first.id,
          # this attribute needs to be updated following the workout creation
          :workout_id => @message.workout_id
        )
        end
############################################################
      else
        # check if Chat table is empty.
        if Message.all.exists?
          # variables to use for updating multiline messages 

          append_date_time = @message.msg_date_time
          append_date = @message.date
          append_time = @message.time
          append_sender = @message.sender
          append_message = @message.message

          @message = Message.all.last
          # @message.date = Date.strptime(@message.msg_date_time, "%m/%d/%y")
          @message.date = Date.parse(@message.msg_date_time)

          @message.message << append_date_time << append_sender << append_message
          @message.save

          # below should not be needed to create new entries for multiline messages since @message.message is appended with the proper fields
          #######
          # Message.find_or_create_by(
          #   :pact_id => pact.id,
          #   :msg_date_time => @message.msg_date_time,
          #   :date => @message.date,
          #   :time => @message.time,
          #   :sender => @message.sender,
          #   :message => @message.message,
          #   :media => @message.media,
          #   :image => @message.image,
          #   :video => @message.video,
          #   :user_id => @message.user_id,
          #   :is_workout => @message.is_workout,
          #   :week_id => pact.weeks.where("start_date <= ? and end_date >= ?", @message.date, @message.date).first.id,
          #   # this attribute needs to be updated following the workout creation
          #   :workout_id => @message.workout_id
          # )
          # the above creates a duplicate for multiline messages. the above needs to happen in order to check for the duplicate due to the nature of multiline messages

          # the following deletes the duplicate.
          # find in messages column, where @message.message is the same as current message, and if unfindable, delete current row.
          # if Message.find_by(message: Message.last.message) != 1
          #   # Message.last == Message.where(message: Message.last.message) returns false
          #   @message.delete
          # end
          #######

        end

      end

    } # end chat_file.each_line

  end

end
