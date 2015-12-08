module PactHelper
  def setup_pact(pact)
    # pact.penalties ||= Penalty.new
    # pact
    pact.penalties.build
    pact
    # 7.times {pact.penalties.build}
  end
end
