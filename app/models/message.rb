class Message < ActiveRecord::Base

  # attr_accessor :pact_id, :user_id, :date_sent, :photo_url

	#######################################################
	# Specifies Associations
	# Read more about Rails Associations here: http://guides.rubyonrails.org/association_basics.html
  belongs_to :pact
  # belongs_to :user

  has_many :workouts

  #######################################################
	# Makes it so that when you print the "Message" object, you print the message instead of the "#<ActiveRecord>blahblah" object name
  alias_attribute :name, :message


  #######################################################
  # deprecated in rails 4
	# Makes it so that you can edit these database columns via ActiveAdmin and forms
	# attr_accessible :message, :pact_id, :user_id, :date_sent, :time_sent_in_seconds, :photo_url


	#######################################################
  # OBJECT ACTIONS
  # Actions you'd want to do on a Message object

  def get_workouts
  	# return all workouts associated with this message (photo)
  end

  def self.import(file)
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

        ####### WEEK LOGIC #######
        # week logic has to be under here due to formatting of date string right under if @message.date != "" && @message.time != "" && @message.sender != "" && @message.message != "" 
        # check if date is a monday
        if @message.date.monday? == true
          @week = Week.new
          puts 'Week.new'
          if Message.all.exists? # check if Messages table exists to check against previous message's date. this if statement may not be necessary since message params are already parsed above
            # check if current message's date is the same as previous message's date
            puts 'Messages table exists'
            if @message.date == Message.last.date
              # if it's the same date, do not save. which means it's still the same week
              puts "current message's date same as previous date"
              # assign current message a week number
              # raise
              @message.week_number = Week.last.week_number
            else
              # if the dates are not the same (which means that this current monday is checked against the previous day, a sunday), save
              @week.week_number = n # n starts off as 1
              print "n = ", n
              print ' week #', @week.week_number
              # set start date to current date, since it's a monday
              @week.start_date = @message.date
              # end date has to be nil because there is no data to put in here yet
              @week.end_date = nil 
                @week.save
                puts 'week saved 1'
              # assign @week.week_number to @message.week_number
              @message.week_number = @week.week_number
              puts "current message's date not same as previous date"
              # set n = n + 1 to set up the next week's week number
              n = n + 1
              print "n = ", n
            end
          else # if Messages table doesn't exist, then this is the first message of the chat that lands on a monday. does not seem to run into this condition so far
            @week.week_number = n
            @week.start_date = @message.date
            @week.end_date = nil
              @week.save
              puts "first message of the chat"
            # assign @week.week_number to @message.week_number
            @message.week_number = Week.last.week_number
            n = n + 1
          end
        elsif @message.date.sunday? == true
          # check if there is a previous week - if no previous week (nil), there is no start_date for this first week(?) message
          puts "it's sunday"
          if Week.last.nil?
            # do nothing
          else
            if @message.date == Message.last.date
              # if it's the same date, do not save. which means it's still the same week
              puts "current message's date same as previous date"
              # assign current message a week number
              # raise
              @message.week_number = Week.last.week_number
            else
              # if @week is not nil, @week will be Week.last because a monday should already exist for this current week.
              # set @week to be Week.last to update database
              @week = Week.last
              # raise
              # check if @week.start_date + 6 days later is equal to current sunday
              if @week.start_date + 6 == @message.date
                @week.end_date = @message.date
                  @week.save
                  puts 'week saved 1'
                # assign @week.week_number to @message.week_number
                @message.week_number = @week.week_number
              end
            end
          end
          print 'sunday ', n
        else # if not monday or sunday
          # check if there is a previous week - if no previous week (nil), there is no start_date for this first week(?) message
          if Week.last.nil?
            # do nothing
          else
            @message.week_number = Message.last.week_number
          end
        end

        # there is redundant week logic going on because first few messages are system messages, so it's parsed differently. week logic is copy+pasted between the different if cases for week parsing

        ####### WEEK LOGIC #######

        # if matching attributes do not exist in db, create
        Message.find_or_create_by(
          :msg_date_time => @message.msg_date_time,
          :date => @message.date,
          :time => @message.time,
          :sender => @message.sender,
          :message => @message.message,
          :media => @message.media,
          :image => @message.image,
          :video => @message.video,
          :user_id => @message.user_id,
          :week_number => @message.week_number,
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

        ####### WEEK LOGIC #######
        # week logic has to be under here due to formatting of date string right under if @message.date != "" && @message.time != "" && @message.sender != "" && @message.message != "" 
        # check if date is a monday
        if @message.date.monday? == true
          @week = Week.new
          puts '2Week.new'
          if Message.all.exists? # check if Messages table exists to check against previous message's date. this if statement may not be necessary since message params are already parsed above
            # check if current message's date is the same as previous message's date
            puts '2Messages table exists'
            if @message.date == Message.last.date
              # if it's the same date, do not save. which means it's still the same week
              puts "2current message's date same as previous date"
              # assign current message a week number
              # raise
              @message.week_number = Week.last.week_number
            else
              # if the dates are not the same (which means that this current monday is checked against the previous day, a sunday), save
              @week.week_number = n # n starts off as 1
              print "n = ", n
              print ' week #', @week.week_number
              # set start date to current date, since it's a monday
              @week.start_date = @message.date
              # end date has to be nil because there is no data to put in here yet
              @week.end_date = nil 
                @week.save
                puts '2week saved'
              # assign @week.week_number to @message.week_number
              @message.week_number = @week.week_number
              puts "2current message's date not same as previous date"
              # set n = n + 1 to set up the next week's week number
              n = n + 1
              print "n = ", n
            end
          else # if Messages table doesn't exist, then this is the first message of the chat that lands on a monday. does not seem to run into this condition so far
            @week.week_number = n
            @week.start_date = @message.date
            @week.end_date = nil
              @week.save
              puts "2first message of the chat"
            # assign @week.week_number to @message.week_number
            @message.week_number = Week.last.week_number
            n = n + 1
          end
        elsif @message.date.sunday? == true
          # check if there is a previous week - if no previous week (nil), there is no start_date for this first week(?) message
          puts "2it's sunday"
          if Week.last.nil?
            # do nothing
          else
            if @message.date == Message.last.date
              # if it's the same date, do not save. which means it's still the same week
              puts "2current message's date same as previous date"
              # assign current message a week number
              # raise
              @message.week_number = Week.last.week_number
            else
              # if @week is not nil, @week will be Week.last because a monday should already exist for this current week.
              # set @week to be Week.last to update database
              @week = Week.last
              # raise
              # check if @week.start_date + 6 days later is equal to current sunday
              if @week.start_date + 6 == @message.date
                @week.end_date = @message.date
                  @week.save
                  puts '2week saved'
                # assign @week.week_number to @message.week_number
                @message.week_number = @week.week_number
              end
            end
          end
          print '2sunday ', n
        else # if not monday or sunday
          # check if there is a previous week - if no previous week (nil), there is no start_date for this first week(?) message
          if Week.last.nil?
            # do nothing
          else
            @message.week_number = Message.last.week_number
          end
        end

        # there is redundant week logic going on because first few messages are system messages, so it's parsed differently. week logic is copy+pasted between the different if cases for week parsing

        ####### WEEK LOGIC #######


        # find in db the following attributes, if they do not exist, create the db entry. @message.user is the "system message", so replace @message.user with @message.message and change @message.user to "System Message"

        Message.find_or_create_by(
          :msg_date_time => @message.msg_date_time,
          :date => @message.date,
          :time => @message.time,
          :message => @message.sender,
          :sender => "System Message",
          :media => @message.media,
          :image => @message.image,
          :video => @message.video,
          :user_id => nil,
          :week_number => @message.week_number,
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
            :msg_date_time => @message.msg_date_time,
            :date => @message.date,
            :time => @message.time,
            :sender => @message.sender,
            :message => @message.message,
            :media => @message.media,
            :image => @message.image,
            :video => @message.video,
            :user_id => @message.user_id,
            :week_number => @message.week_number,
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
