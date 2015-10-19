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
      if @message.date != "" && @message.time != "" && @message.sender != "" && @message.message != "" 
        # format date
        @message.date = Date.strptime(@message.msg_date_time, "%m/%d/%y")
        
        # logic that checks if message contains either an image or video, and if so media is set to true (boolean) and the other is set to nil in order to render the media in the view with an if statement
        if @message.message.include? ".jpg <attached>" 
          @message.image = @message.message.partition(".jpg")[0]
          @message.media = true
          @message.video = nil
          puts 'has jpg'
        elsif @message.message.include? ".mp4 <attached>"
          @message.video = @message.message.partition(".mp4")[0]
          @message.media = true
          @message.image = nil
          puts 'has mp4'
        else
          @message.media = false
          @message.image = nil
          @message.video = nil
          puts 'no media'
        end
        ####### USER LOGIC #######
        @user = User.new
        @user.first_name, sep, @user.last_name = @message.sender.partition(" ")
        @user.username = @message.sender
        @user.email = @user.first_name.downcase + @user.last_name.downcase + '@example.com'
        # @user.save
        # if User.all.exists? == true
        # if User's first and last name exist, do not save, else, save
          # if User.find_by(first_name: @user.first_name).first_name == @user.first_name && User.find_by(last_name: @user.last_name).last_name == @user.last_name
          
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
            if n == 47
              # raise
            end
          end
        ####### USER LOGIC #######
        n = n + 1
        # if date, time, user, message do not exist in db, create
        Message.find_or_create_by(
          :msg_date_time => @message.msg_date_time,
          :date => @message.date,
          :time => @message.time,
          :sender => @message.sender,
          :message => @message.message,
          :media => @message.media,
          :image => @message.image,
          :video => @message.video,
          :user_id => @message.user_id
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

      elsif @message.date != "" && @message.time != "" && @message.sender != "" && @message.message = ""
        # if message is blank, it's a system message

        # find in db the following attributes, if they do not exist, create the db entry. @message.user is the "system message", so replace @message.user with @message.message and change @message.user to "System Message"
        @message.date = Date.strptime(@message.msg_date_time, "%m/%d/%y")

        Message.find_or_create_by(
          :msg_date_time => @message.msg_date_time,
          :date => @message.date,
          :time => @message.time,
          :message => @message.sender,
          :sender => "System Message",
          :media => @message.media,
          :image => @message.image,
          :video => @message.video
        )
        
      else
        # check if Chat table is empty.
        if Message.all.exists?
          # variables to use for updating multiline messages 

          previous_date_time = @message.msg_date_time
          previous_date = @message.date
          previous_time = @message.time
          previous_sender = @message.sender
          previous_message = @message.message
          # puts previous_date, 'date'
          # puts previous_time, 'time'
          # puts previous_user, 'user'
          # puts previous_message, 'previous message'
          @message = Message.all.last
          @message.date = Date.strptime(@message.msg_date_time, "%m/%d/%y")

          @message.message << previous_date_time << previous_sender << previous_message
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
            :user_id => @message.user_id
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
