class Week < ActiveRecord::Base
	#######################################################
	# Specifies Associations
	# Read more about Rails Associations here: http://guides.rubyonrails.org/association_basics.html
	belongs_to :pact
  has_many :messages
  has_many :goals
  has_many :payments, :through => :pact
  accepts_nested_attributes_for :payments 


	#######################################################
  # deprecated in rails 4
	# Makes it so that you can edit these database columns via ActiveAdmin and forms
  # attr_accessible :end_date, :start_date, :week_number, :pact_id


  def get_previous_week
    @week_number = self.week_number
    @pact = self.pact 
    if @week_number == 1
      nil
    else
      @previous_week = get_week(@pact, @week_number - 1)
    end
  end

  def get_next_week
    @week_number = self.week_number
    @pact = self.pact
    @next_week = get_week(@pact, @week_number + 1)
  end

  def get_week(pact, week_number)
    Week.where(:pact_id=>pact.id).where(:week_number=>week_number).first
  end


end
