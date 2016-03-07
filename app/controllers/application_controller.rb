class ApplicationController < ActionController::Base
  protect_from_forgery
  # before_action :authenticate_user!

  before_action :current_pact, :current_week, :this_week, :render_sidebar
  # current_pact method gives error whenever a view is not from pacts controller

  def current_pact
    if (params[:controller] == "pacts") == true
      if params[:pact_id] || params[:id]
        current_pact = Pact.find(params[:pact_id] || params[:id])
      end
    else
      current_pact = nil
    end
  end

  def current_week
  	# if(params.has_key?(:week_id))
  	# 	Week.find(params[:week_id])
   #  else
   #    this_week
  	# end
  end

  def this_week(pact=current_pact)
    today = Date.today
    if pact
      week = Week.where(["pact_id = ? and start_date <= ? and end_date >= ?", pact.id, today, today]).first
      if !week
        week = Week.where(["pact_id = ?", pact.id]).last
      end
      week
    else
      nil
    end
  end

  def render_sidebar
    @active_pacts = Pact.all.order(:created_at)
    @current_pact = current_pact
    @current_week = current_week
    @this_week = this_week
  end

end
