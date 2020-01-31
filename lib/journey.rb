require_relative 'oystercard'

class Journey
  PENALTY_FARE = 6
  MINIMUM_FARE = 1

  attr_reader :in_journey, :entry_station, :exit_station
    
  def start(station)
    #only allow if balance allows
    #when tap on, create entry station
    #change status of in_journey to true
    @entry_station = station
    @in_journey = true
  end
  
  def finish(station)
    #when tap out create an exit station
    #apply fare
    #create journey in Oystercard
    #change status of in_journey to false
    @exit_station = station
    @in_journey = false
  end

  def fare
    #calculating the fare of a journey
    #entry and exit = minimum fare (1)
    #no entry and no exit = penalty fare (1)
    return MINIMUM_FARE if journey_complete?
    return PENALTY_FARE if has_station?
    0
  end

  private

  def journey_complete?
    !@in_journey && @entry_station && @exit_station
  end

  def has_station?
    @entry_station || @exit_station
  end

end