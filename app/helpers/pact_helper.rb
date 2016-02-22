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
      pact.goals.build
    else
      pact
    end
    pact
  end


  # not needed. helper method in WeekHelper
  def setup_pact_payments(pact)

    if !pact.payments.present?
      pact.payments
    else
      pact.payments
    end

    pact
  end

end
