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
    # only build if goals do not exist yet

    if !pact.goals.present?
      # debugger
      pact.goals.build
      puts 'hello helper'
    else
      pact
      puts 'bye helper'
      # debugger
    end
    pact
  end


end
