require 'journey'

describe Journey do
  let(:station1) { double(:entry_station) }
  let(:station2) { double(:exit_station) }

  it 'has a minimum fare' do
    expect(Journey::MINIMUM_FARE).to eq 1
  end

  describe "#fare" do
   it 'should be zero by default' do
    expect(subject.fare).to eq(0)
   end
  end
  
  context 'when starting a journey' do
    before(:example) do
      subject.start(station1)
    end

    it 'should be in journey' do
      expect(subject.in_journey).to eq true
    end

    it 'should have an entry station' do
      expect(subject.entry_station).to eq station1
    end

    it 'should charge a penalty fare if there is no exit station' do
      expect(subject.fare).to eq Journey::PENALTY_FARE
    end
  end

  context 'when finishing a journey' do
    before(:example) do
      subject.start(station1)
      subject.finish(station2)
    end

    it 'should not be in journey' do
      expect(subject.in_journey).to eq false
    end

    it 'should have an exit station' do
      expect(subject.exit_station).to eq station2
    end

    it 'should charge the minimum fare if there is an exit station' do
      expect(subject.fare).to eq Journey::MINIMUM_FARE
    end
  end

  context "when finishing a journey that never started" do
    it 'should chare a penalty fare' do
      subject.finish(station2)
      expect(subject.fare).to eq Journey::PENALTY_FARE
    end
  end
end
