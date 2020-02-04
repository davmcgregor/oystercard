require 'oystercard'
describe Oystercard do
  let(:limit) { Oystercard::MAXIMUM_BALANCE }
  let(:min_balance) { Oystercard::MINIMUM_BALANCE }
  let(:min_fare) { 1 }
  let(:penalty_fare) { 6 }
  let(:station) { double :station, zone: 1 }
  let(:station2) { double :station, zone: 3 }
  let(:zone_fare) { 2 }
  let(:journey) { double :journey, entry_station: station, exit_station: station2 }
  let(:journey_log) { double :journey_log, journeys: [journey], start: nil, finish: nil }
  let(:journey_log_class) { double :journey_log_class, new: journey_log }

  subject(:card) { Oystercard.new journey_log }

  describe '#initialize' do
    it 'should initialize the class with a balance of zero' do
      expect(card.balance).to eq(0)
    end
  end

  describe '#top_up' do
    it 'should add given amount to balance' do
      card.top_up(10)
      expect(card.balance).to eq(10)
    end

    it 'should not push balance above limit' do
      limit.times { card.top_up 1 }
      amount = 1
      message = "Can't exceed #{limit} with #{amount}"
      expect { card.top_up amount }.to raise_error "Maximum balance of #{limit} exceeded"
    end
  end

  describe '#touch_in' do
    it 'should raise an error if user tries to travel under minimum balance' do
      allow(journey_log).to receive(:in_journey?).and_return(false)
      message = "Insuffient funds, please top up by #{min_balance}"
      expect { card.touch_in(station) }.to raise_error "Balance not high enough for journey"
    end

    context "with credit" do
      before(:each) { card.top_up(20) }

      it "should start a journey" do
        allow(journey_log).to receive(:in_journey?).and_return(false)
        expect(journey_log).to receive(:start).with station
        card.touch_in(station)
      end

      it "should deduct a penalty if the previous journey wasn't complete" do
        allow(journey_log).to receive(:in_journey?).and_return(false, true)
        allow(journey).to receive(:fare).and_return(penalty_fare)
        subject.touch_in(station)
        expect { subject.touch_in(station) }.to change { subject.balance }.by -penalty_fare
      end
    end
  end

  describe '#touch_out' do
    before do
      card.top_up(50)
    end

    context "when a journey has been completed" do
      before(:each) do
        allow(journey).to receive(:fare).and_return(min_fare + zone_fare)
      end

      it "should deduct the minimum and zone fare" do
        allow(journey_log).to receive(:in_journey?).and_return(false)
        card.touch_in(station)

        expect { subject.touch_out(station2) }.to change { subject.balance }.by -(min_fare + zone_fare)
      end
    end

    it "should deduct a penalty if the journey wasn't started" do
      allow(journey_log).to receive(:in_journey?).and_return(false)
      allow(journey).to receive(:fare).and_return(penalty_fare)
      expect { subject.touch_out(station) }.to change { subject.balance }.by -penalty_fare
    end
  end
end