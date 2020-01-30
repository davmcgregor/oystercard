require 'oystercard'

describe Oystercard do
  subject(:oyster) { described_class.new }
  let(:station) {double("fake station")}

  it "has a balance of 0 by default" do
    expect(oyster.balance).to eq 0
  end

  it 'initializes an empty array' do
    expect(oyster.journeys).to eq []
  end
    
  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'can top up the balance' do
      expect{ oyster.top_up 1 }.to change{ oyster.balance }.by 1
    end

    it "raises an error if the maximum balance is exceeded" do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      oyster.top_up maximum_balance
      expect{ oyster.top_up(1) }.to raise_error "Maximum balance of #{maximum_balance} exceeded"
      end
    end

  describe '#deduct' do
    it { is_expected.to respond_to(:deduct).with(1).argument }
        
    it "reduces the balance by a specified amount" do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      oyster.top_up(maximum_balance)
      oyster.deduct(40)
      expect(oyster.balance).to eq(maximum_balance - 40)
    end

    it 'deducts an amount from the balance' do
      oyster.top_up(20)
      expect{ oyster.deduct 3}.to change{ oyster.balance }.by -3
      end
    end
######################################

    it 'has a minimum fare' do
        expect(Oystercard::MINIMUM_FARE).to eq 1
    end

    describe "#touch_in" do
      before(:example) do
        oyster.top_up(Oystercard::MAXIMUM_BALANCE)
        allow(station).to receive(:name) { "Aldgate East" }
      end
        
      it { is_expected.to respond_to(:touch_in).with(1).argument }
        
      it 'updates an Oystercard to remember the entry station' do
        expect { oyster.touch_in(station.name) }.to change{ oyster.entry_station }.to station.name 
      end

      it 'changes in_journey to true' do
        expect(oyster.touch_in(station.name)).to be true
      end

      it "can touch in" do
        oyster.touch_in(station.name)
        expect(oyster).to be_in_journey
      end
    end

    describe "#touch_in" do
      it 'requires minimum balance for a journey' do
        expect{ oyster.touch_in(station) }.to raise_error "Balance not high enough for journey"
      end
    end
    
    describe "#in_journey?" do
      it { is_expected.to respond_to(:in_journey?).with(0).argument }

      it 'returns false at the start' do
        expect(oyster.in_journey?).to eq false
      end

      it 'returns true when the user has touched in' do
        oyster.top_up(Oystercard::MAXIMUM_BALANCE)
        oyster.touch_in(station)
        expect(oyster.in_journey?).to be true
      end

     it 'returns false when the user has touched out' do
        allow(station).to receive(:name).and_return("Aldgate East", "Angel")
        oyster.touch_out(station.name)
        expect(oyster.in_journey?).to be false
      end

      it 'returns true when an entry station exists' do
        oyster.top_up(Oystercard::MAXIMUM_BALANCE)
        allow(station).to receive(:name) { "Aldgate East" }
        oyster.touch_in(station.name)
        expect(oyster.in_journey?).to be true
      end
      
      it 'returns false when an entry station does not exist' do
        oyster.top_up(Oystercard::MAXIMUM_BALANCE)
        allow(station).to receive(:name).and_return("Aldgate East", "Angel")
        oyster.touch_in(station.name)
        oyster.touch_out(station.name)
        expect(oyster.in_journey?).to be false
      end
    end

    describe "#touch_out" do
      it { is_expected.to respond_to(:touch_out).with(1).argument }
      
      it 'changes entry station to nil' do
        allow(station).to receive(:name).and_return("Aldgate East", "Angel")
        oyster.top_up(Oystercard::MAXIMUM_BALANCE)
        oyster.touch_in(station.name)
        oyster.touch_out(station.name)
        expect(oyster.entry_station).to eq nil
      end

      it 'changes in_journey to false' do
        oyster.top_up(Oystercard::MAXIMUM_BALANCE)
        allow(station).to receive(:name).and_return("Aldgate East", "Angel")
        oyster.touch_in(station.name)
        oyster.touch_out(station.name)
        expect(oyster).not_to be_in_journey
      end
 
      it 'deducts the minimum fare from the balance at touch out' do
       oyster.top_up(Oystercard::MAXIMUM_BALANCE)
       allow(station).to receive(:name).and_return("Aldgate East", "Angel")
       oyster.touch_in(station.name)
       expect { oyster.touch_out(station.name) }.to change{ oyster.balance }.by -(Oystercard::MINIMUM_FARE)
      end
    end

    describe "initialization" do 
        it 'has a station when initailized set to nil' do
            testclass = Oystercard.new
            expect(testclass.entry_station).to eq nil
        end
    end

    describe "#create_journey" do
      it 'responds to create_journey' do
        expect(oyster).to respond_to(:create_journey).with(2).arguments  
      end  

      it 'should create a hash with teh entry and exit journey' do
        allow(station).to receive(:name).and_return("Aldgate East", "Angel")
        expect(oyster.create_journey(station.name, station.name)).to eq({"JID"=>1, "Entry"=>"Aldgate East", "Exit"=>"Angel"})
      end
    end
end