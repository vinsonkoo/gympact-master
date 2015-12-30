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

  has_many :messages
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

        # the following logic only creates goals for weeks that haven't passed yet, so any weeks before the current week will not have any goals created. goals not created for past weeks can be created through activeadmin (?)
        @pact.weeks.each do |pw|
          start_date = pw.start_date
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
          else
            # if the pact's week is not in the future, do nothing
          end # @pacts.weeks.each do |pw|
        end

      else

        # LOGIC IS INCOMPLETE. GOALS ARE CREATED FOR 1 USER AND NOT ALL, SO LOOP ENDS WHEN ENOUGH GOALS ARE CREATED FOR 1 USER
        puts 'hello'
        # if pact is not active, update all goals for all weeks for each user
        total_weeks = @pact.weeks.count
        @pact.weeks.each do |pw|
          n = 1
          @pact.goals.each do |pg|            
            user = pg.user_id
            goal = pg.goal
            new_goal = @pact.goals.build
            new_goal.user_id = user
            new_goal.goal = goal
            new_goal.week_id = pw.id + 1
            if (n + 1) < total_weeks # * (@pact.users.count)
              if @pact.weeks.count < new_goal.week_id
              else
              new_goal.save
              end
            else
            end
            # debugger
            n = n + 1
          end
        end
      end

    end
    
  end # def check_goals

  def self.import(file, pact)
    n = 1
    # open the file
    message_file = File.open(file.path, "r")
    # begin reading each line
    message_file.each_line { |line|


      # @message = Message.new
      @message = Message.new
      # separate date/time from the rest of the message (sender, message)
      @message.msg_date_time, sep, @message.message = line.partition(": ")
      # separate date and time
      @message.date, sep, @message.time = @message.msg_date_time.partition(", ")
      # separate sender/user and message
      @message.sender, sep, @message.message = @message.message.partition(": ")

      # if fields are not blank, save. logic to check if any fields are blank before saving. date and time will most likely never be blank due to the constant format unlike users and messages, but will be checked anyway.
############################################################
      if @message.date != "" && @message.time != "" && @message.sender != "" && @message.message != "" 
        # format date
        @message.date = Date.strptime(@message.msg_date_time, "%m/%d/%y")
        
        # logic that checks if message contains either an image or video, and if so media is set to true (boolean) and the other is set to nil in order to render the media in the view with an if statement
        if @message.message.include? ".jpg <attached>" 
          @message.image = @message.message.partition(".jpg")[0]
          @message.media = true
          @message.video = nil
          @message.is_workout = true
          puts 'has jpg'
        elsif @message.message.include? ".mp4 <attached>"
          @message.video = @message.message.partition(".mp4")[0]
          @message.media = true
          @message.image = nil
          @message.is_workout = true
          puts 'has mp4'
        else
          @message.media = false
          @message.image = nil
          @message.video = nil
          @message.is_workout = false
          puts 'no media'
        end

        ####### USER LOGIC #######
        @user = User.new
        @user.first_name, sep, @user.last_name = @message.sender.partition(" ")
        @user.username = @message.sender
        @user.email = @user.first_name.downcase + @user.last_name.downcase + '@example.com'
          
        if User.find_by(last_name: @user.last_name, first_name: @user.first_name) == nil
          # user not found, do not save
          # raise
          puts 'username ' + @user.username
          @user.save
          @message.user_id = @user.id
          puts 'user not found'
        else
          puts 'user found'
          # raise
          found_user = User.find_by(username: @user.username, first_name: @user.first_name)
          @user = User.find_by(username: found_user.username)
          @message.user_id = @user.id
        end
        ####### USER LOGIC #######

        # if matching attributes do not exist in db, create
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
          # :week_number => @message.week_number,
          :is_workout => @message.is_workout
        )


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

        # puts @message.all
        # currently, this does not check for media. it will create a new row in the db with "<image omitted>", if a new chat file is uploaded
############################################################
      elsif @message.date != "" && @message.time != "" && @message.sender != "" && @message.message = ""
        # if message is blank, it's a system message

        @message.date = Date.strptime(@message.msg_date_time, "%m/%d/%y")

        # find in db the following attributes, if they do not exist, create the db entry. @message.user is the "system message", so replace @message.user with @message.message and change @message.user to "System Message"
        Message.find_or_create_by(
          :pact_id => pact.id,
          :msg_date_time => @message.msg_date_time,
          :date => @message.date,
          :time => @message.time,
          :message => @message.sender,
          :sender => "System Message",
          :media => @message.media,
          :image => @message.image,
          :video => @message.video,
          :user_id => nil,
          # :week_number => @message.week_number,
          :is_workout => @message.is_workout
        )
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
          @message.date = Date.strptime(@message.msg_date_time, "%m/%d/%y")

          @message.message << append_date_time << append_sender << append_message
          # @message.save

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
            # :week_number => @message.week_number,
            :is_workout => @message.is_workout
          )
          # the above creates a duplicate for multiline messages. the above needs to happen in order to check for the duplicate due to the nature of multiline messages

          # the following deletes the duplicate.
          # find in messages column, where @message.message is the same as current message, and if unfindable, delete current row.
          if Message.find_by(message: Message.last.message) != 1
            # Message.last == Message.where(message: Message.last.message) returns false
            @message.delete
          end

        end

      end

    } # end chat_file.each_line

  end

end
