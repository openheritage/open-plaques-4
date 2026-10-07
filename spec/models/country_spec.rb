require "rails_helper"

describe Country, type: :model do
  it "has a valid factory" do
    expect(create :country).to be_valid
  end

  describe "#as_json" do
    context "with nothing set" do
      let(:country) { build :country }

      it "is json" do
        # can do better than this. Probably by using https://github.com/collectiveidea/json_spec
        expect(country.as_json.to_s.size).to be > 10
      end
    end
  end

  describe "#uri" do
    context "when unsaved" do
      let(:country) { build :country }

      it "is nil" do
        expect(country.uri).to be_nil
      end
    end

    context "with an id" do
      let(:country) { create :country }

      it "is an http address" do
        expect(country.uri).to eq "https://openplaques.org/places/#{country.alpha2}.json"
      end
    end
  end

  describe "#to_s" do
    context "with nothing set" do
      let(:country) { build :country, name: nil }

      it "is blank" do
        expect(country.to_s).to eq ""
      end
    end

    context "with a name set" do
      let(:country) { build :country, name: "binky" }

      it "is nil" do
        expect(country.name).to eq "binky"
      end
    end
  end
end
