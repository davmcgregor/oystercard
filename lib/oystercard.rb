class Oystercard
    MAXIMUM_BALANCE = 90
    MINIMUM_FARE = 1
    
    attr_reader :balance
    attr_accessor :in_journey

    def initialize
        @balance = 0
        @in_journey = false
    end

    def top_up(amount)
        fail "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if @balance + amount > MAXIMUM_BALANCE
        @balance += amount
    end

    def deduct(amount)
        @balance -= amount
    end

    def in_journey?
        @in_journey
    end

    def touch_in
        raise "Balance not high enough for journey" if @balance < MINIMUM_FARE
        @in_journey = true
    end

    def touch_out
        @balance -= MINIMUM_FARE
        @in_journey = false
    end
end