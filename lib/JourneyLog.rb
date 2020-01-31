class JourneyLog
  attr_reader :journey_log

  def initialize(journey_class = Journey)
    @in_journey = false
    @journey_log = []
    @journey_class = journey_class
  end

  def in_journey?
    @in_journey
  end

  def start(entry_station)
    @journey_log << @journey_class.new
    @journey_log.last.start(entry_station)
    @in_journey = true
  end

  def finish(exit_station)
    @journey_log.last.finish(exit_station)
    @in_journey = false
  end

  def journeys
    @journey_log.dup
  end

  private

  def current_journey
    return journey_log.last if in_journey?  
  end
end