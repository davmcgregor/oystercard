class Oystercard
    MAXIMUM_BALANCE = 90
    MINIMUM_FARE = 1
    
    attr_reader :balance
    attr_accessor :entry_station

    def initialize
        @balance = 0
        @entry_station = nil
    end

    def top_up(amount)
        fail "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if @balance + amount > MAXIMUM_BALANCE
        @balance += amount
    end

    def deduct(amount)
        @balance -= amount
    end

    def in_journey?
        @entry_station ? true : false
    end

    def touch_in(station)
        raise "Balance not high enough for journey" if @balance < MINIMUM_FARE
        @entry_station = station
        in_journey?
    end

    def touch_out
        @balance -= MINIMUM_FARE
        @entry_station = nil
        in_journey?
    end
end