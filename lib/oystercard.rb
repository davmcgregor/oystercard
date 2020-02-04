require_relative 'station'
require_relative 'journey'
require_relative 'JourneyLog'

class Oystercard
    MAXIMUM_BALANCE = 90
    MINIMUM_BALANCE = 1
    
    attr_reader :balance
    
    def initialize(journey_log = JourneyLog.new, balance = 0)
        @balance = balance
        @journey_log = journey_log
    end

    def touch_in(station)
      deduct @journey_log.journeys.last.fare if @journey_log.in_journey?
      raise "Balance not high enough for journey" if @balance < MINIMUM_BALANCE
      @journey_log.start(station)
    end

    def journey_history
      @journey_log.journeys
    end

    def touch_out(station)
      @journey_log.finish(station)
      deduct(@journey_log.journeys.last.fare)
    end
    
    def top_up(amount)
      fail "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if @balance + amount > MAXIMUM_BALANCE
      @balance += amount
    end

    def deduct(fare)
      @balance -= fare
    end

end