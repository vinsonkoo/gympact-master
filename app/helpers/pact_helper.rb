module PactHelper
  def setup_pact_penalties(pact)
    
    # only build if penalties do not exist yet
    if !pact.penalties.present?
      8.times {pact.penalties.build}
    else

    end
    pact
  end

  def setup_pact_goals(pact)
    n = 0
    pact.users.each do |pu|
      pact.goals.build
      
    end

    pact
  end

end
