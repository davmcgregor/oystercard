require 'JourneyLog'

describe JourneyLog do
  let(:station1) { double(:entry_station) }
  let(:station2) { double(:exit_station) }
  let(:journey) { double :journey, start: nil, finish: nil }
  let(:journey_class) { double :journey_class, new: journey }

  subject (:log) { JourneyLog.new journey_class}

  context 'when there are no journeys' do
    it 'should not be in journey' do
      expect(log.in_journey?).to eq false
    end
  end

  context 'when a journey has been started' do
    before(:each) { log.start(station1) }

    it 'should be in journey' do
      expect(log.in_journey?).to eq true
    end

    it 'should give the start station to the journey' do
      expect(journey).to have_received(:start).with station1
    end
  
    context 'when a journey has finished' do
      before(:each) { log.finish(station2) }

      it 'should not be in journey' do
        expect(log.in_journey?).to eq false
      end

      it 'should give the finish station to the journey' do
        expect(journey).to have_received(:finish).with station2
      end
    end
  end
end