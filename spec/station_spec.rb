require 'station'

describe Station do
  let(:station) {Station.new(name: "Aldgate East", zone: 1)}

  it 'has a name' do
    expect(station.name).to eq("Aldgate East")
  end

  it 'has a zone' do
    expect(station.zone).to eq(1)
  end

end