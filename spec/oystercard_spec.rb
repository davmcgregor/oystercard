require 'oystercard'

describe Oystercard do

    it "has a balance of 0 by default" do
        expect(subject.balance).to eq 0
    end
    
    describe '#top_up' do
    
        it { is_expected.to respond_to(:top_up).with(1).argument }

        it 'can top up the balance' do
            expect{ subject.top_up 1 }.to change{ subject.balance }.by 1
        end

        it "raises an error if the maximum balance is exceeded" do
            maximum_balance = Oystercard::MAXIMUM_BALANCE
            subject.top_up maximum_balance
            expect{ subject.top_up(1) }.to raise_error "Maximum balance of #{maximum_balance} exceeded"
        end
    end

    describe '#deduct' do
        it { is_expected.to respond_to(:deduct).with(1).argument }
        
        it "reduces the balance by a specified amount" do
            maximum_balance = Oystercard::MAXIMUM_BALANCE
            subject.top_up(maximum_balance)
            subject.deduct(40)
            expect(subject.balance).to eq(maximum_balance - 40)
        end

        it 'deducts an amount from the balance' do
            subject.top_up(20)
            expect{ subject.deduct 3}.to change{ subject.balance }.by -3
        end
    end
######################################

    it 'has a minimum fare' do
        expect(Oystercard::MINIMUM_FARE).to eq 1
    end

    describe "#touch_in" do
        it { is_expected.to respond_to(:touch_in).with(0).argument }

        it 'changes in_journey to true' do
            subject.top_up(2)
            expect(subject.touch_in).to be true
        end

        it "can touch in" do
            subject.top_up(2)
            subject.touch_in
            expect(subject).to be_in_journey
        end

        it 'requires minimum £1 for a journey' do
            expect{ subject.touch_in}.to raise_error "Balance not high enough for journey"
        end

    end

    describe "#in_journey?" do
      it { is_expected.to respond_to(:in_journey?).with(0).argument }

      it 'returns false at the start' do
        expect(subject.in_journey?).to eq false
      end

      it 'returns true when the user has touched in' do
        subject.top_up(2)
        subject.touch_in
        expect(subject.in_journey?).to be true
      end

     it 'returns false when the user has touched out' do
        subject.touch_out
        expect(subject.in_journey?).to be false
      end
    end

    describe "#touch_out" do
      it { is_expected.to respond_to(:touch_out).with(0).argument }

      it 'changes in_journey to false' do
        subject.top_up(2)
        subject.touch_in
        expect(subject.touch_out).to be false
      end
    end
    
end