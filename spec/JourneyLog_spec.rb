require 'JourneyLog'

describe JourneyLog do
  let(:station) { double :station }
  let(:journey) { spy :journey, start: nil }
  let(:journey_class) { double :journey_class, new: journey }
  
  subject { JourneyLog.new journey_class }
  context "when there are no journeys" do
    it "should not be in journey" do
      expect(subject.in_journey?).to be false
    end
  end
  context "when we have started a journey" do
    before(:each) { subject.start station }
    it "should be in journey" do
      expect(subject.in_journey?).to be true
    end
    it "should give the start station to the journey" do
      expect(journey).to have_received(:start).with station 
    end
    context "when we have finished a journey" do
      before(:each) { subject.finish station }
      it "should not be in a journey" do
        expect(subject.in_journey?).to be false
      end
      it "should give the finish station to the journey" do
        expect(journey).to have_received(:finish).with station
      end

    end

    context "when we want to see our journeys" do
      it "should return a copy of the journey log" do
        expect(subject.journeys).to include(journey)
      end
    end
  end
end