require 'oystercard'

describe Oystercard do
    let(:station) {double("fake station")}

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
        before(:example) do
            subject.top_up(2)
            allow(station).to receive(:name) { "Aldgate East" }
        end
        
        it { is_expected.to respond_to(:touch_in).with(1).argument }
        
        it 'updates an Oystercard to remember the entry station' do
            expect { subject.touch_in(station.name) }.to change{ subject.entry_station }.to station.name 
        end

        it 'changes in_journey to true' do
            expect(subject.touch_in(station.name)).to be true
        end

        it "can touch in" do
            subject.touch_in(station.name)
            expect(subject).to be_in_journey
        end
    end

    describe "#touch_in" do
        it 'requires minimum balance for a journey' do
            expect{ subject.touch_in(station) }.to raise_error "Balance not high enough for journey"
        end
    end
    
    describe "#in_journey?" do
      it { is_expected.to respond_to(:in_journey?).with(0).argument }

      it 'returns false at the start' do
        expect(subject.in_journey?).to eq false
      end

      it 'returns true when the user has touched in' do
        subject.top_up(2)
        subject.touch_in(station)
        expect(subject.in_journey?).to be true
      end

     it 'returns false when the user has touched out' do
        subject.touch_out
        expect(subject.in_journey?).to be false
      end
    end

    describe "#touch_out" do
      it { is_expected.to respond_to(:touch_out).with(0).argument }
      
      it 'changes entry station to nil' do
        subject.top_up(2)
        allow(station).to receive(:name) { "Aldgate East" }
        subject.touch_in(station.name)
        expect { subject.touch_out }.to change{ subject.entry_station}.to nil
      end

      it 'changes in_journey to false' do
        subject.top_up(2)
        subject.touch_in(station)
        expect(subject.touch_out).to be false
      end
 
      it 'deducts the minimum fare from teh balance at touch out' do
       subject.top_up(20)
       subject.touch_in(station)
       expect { subject.touch_out }.to change{ subject.balance }.by -described_class::MINIMUM_FARE
      end
    end

    describe "initialization" do 
        it 'has a station when initailized set to nil' do
            testclass = Oystercard.new
            expect(testclass.entry_station).to eq nil
        end
    end
end