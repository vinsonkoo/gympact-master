module WeekHelper

  def setup_pact_payments(pact, user)
    @payment = Payment.find_by( 'pact_id = ? and user_id = ?', pact.id, user.id)

  end
end
