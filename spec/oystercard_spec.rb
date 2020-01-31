require 'oystercard'

describe Oystercard do
  let(:max_balance) { Oystercard::MAXIMUM_BALANCE }
  let(:min_fare) { 1 }
  let(:station) { double :station }
  let(:station2) {double :station }
  let(:journey) { double :journey, start: nil, finish: nil, fare: 0}
  let(:journey_class) { double :journey_class, new: journey }

  subject (:oyster) { Oystercard.new journey_class}

  describe "initialization" do 
    it "has a balance of 0 by default" do
      expect(oyster.balance).to eq 0
    end
  
    it 'initializes an empty array' do
      expect(oyster.journey_list).to eq []
    end  
  end

  describe '#top_up' do
    it { is_expected.to respond_to(:top_up).with(1).argument }

    it 'can top up the balance' do
      expect{ oyster.top_up 1 }.to change{ oyster.balance }.by 1
    end

    it "raises an error if the maximum balance is exceeded" do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      oyster.top_up(maximum_balance)
      expect{ oyster.top_up(1) }.to raise_error "Maximum balance of #{maximum_balance} exceeded"
    end
  end

  describe "#touch_in" do        
    it { is_expected.to respond_to(:touch_in).with(1).argument }
    
    it 'requires minimum balance for a journey' do
      expect{ oyster.touch_in(station) }.to raise_error "Balance not high enough for journey"
    end

    context 'with enough balance for a journey' do
      before(:each) { oyster.top_up(max_balance) }

      it 'should start a journey' do
        expect(journey).to receive(:start).with station
        oyster.touch_in(station)
      end

      it 'should deduct a penalty if the previous journey was not complete' do
        allow(journey).to receive(:fare).and_return(Journey::PENALTY_FARE)
        oyster.touch_in(station)
        expect{ oyster.touch_in(station) }.to change { oyster.balance }.by -Journey::PENALTY_FARE
      end
    end
  end

  describe "#touch_out" do
    before do
      oyster.top_up(Oystercard::MAXIMUM_BALANCE)
      oyster.touch_in(station)
      oyster.touch_out(station2)
    end
    
    it 'changes the in_journey status to be false' do
      expect(oyster.in_journey?).to be_falsey
    end

    it 'should accept an exit station argument and store it' do
      expect(oyster.journey_list[0]).to eq(journey)
    end

    it 'should deduct a standard fare' do
      oyster.touch_in(station)
      allow(journey).to receive(:fare).and_return(Journey::MINIMUM_FARE)
      expect { subject.touch_out(station2) }.to change { subject.balance }.by -1
    end

    it 'should deduct a penalty if the journey was not started' do
      allow(journey).to receive(:fare).and_return(Journey::PENALTY_FARE) 
      expect { subject.touch_out(station) }.to change { subject.balance }.by -6
    end
  end    
end