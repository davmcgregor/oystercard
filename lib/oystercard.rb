class Oystercard
    MAXIMUM_BALANCE = 90
    
    attr_reader :balance, :journey_list

    def initialize(journey_class = Journey, balance = 0)
        @balance = balance
        @journey_list = []
        @journey_class = journey_class
    end

    def top_up(amount)
        fail "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if @balance + amount > MAXIMUM_BALANCE
        @balance += amount
    end

    def in_journey?
        @current_journey
    end

    def touch_in(station)
      deduct(@current_journey.fare) if in_journey?  
      raise "Balance not high enough for journey" if @balance < Journey::MINIMUM_FARE
      start_journey(station)
    end

    def touch_out(station)
      finish_journey(station)
      record_journey
    end

    private

    def record_journey
      @journey_list << @current_journey
      @current_journey = nil
    end

    def start_journey(station)
      @current_journey = @journey_class.new
      @current_journey.start(station)
    end

    def finish_journey(station)
      @current_journey = @journey_class.new unless in_journey?
      @current_journey.finish(station)
      deduct(@current_journey.fare)
    end

    def deduct(fare)
      @balance -= fare
    end
end