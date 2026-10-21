require "rails_helper"

describe Wikidata do
  describe "#search_wikidata" do
    context "with an unfindable name" do
      it "returns nothing" do
        expect(described_class.qcode("zdfgad")).to be_nil
      end
    end

    context "with an ambiguous name" do
      it "returns nothing" do
        expect(described_class.qcode("John Smith")).to be_nil
      end
    end

    context "with an ambiguous name with dates" do
      it "returns someone with the right name and dates" do
        expect(described_class.qcode("James Duffy (1889-1969)")).to eq("Q4155328")
      end
    end

    context "with an ambiguous name with only death date" do
      it "returns someone with the right name and dates" do
        expect(described_class.qcode("James Duffy (d.1969)")).to eq("Q4155328")
      end
    end

    context "with an ambiguous name with only birth date" do
      it "returns someone with the right name and dates" do
        expect(described_class.qcode("James Duffy (b.1889)")).to eq("Q4155328")
      end
    end

    context "with an unambiguous name" do
      it "returns a Wikidata id" do
        expect(described_class.qcode("Myra Hess")).to eq("Q269848")
      end
    end

    context "with an unambiguous name with the right dates" do
      it "returns a Wikidata id" do
        expect(described_class.qcode("Myra Hess (1890-1965)")).to eq("Q269848")
      end
    end

    context "with a name which Wikidata do not match" do
      it "returns a Wikidata id" do
        expect(described_class.qcode("abolitionist")).to be_nil
      end
    end

    context "with a name which Wikidata hold starting with uppercase" do
      it "returns a Wikidata id" do
        expect(described_class.qcode("anchorite")).to eq("Q1146843")
      end
    end

    context "with a name with an unusual character" do
      it "returns nil" do
        sub = "Discoverer of the variation of δ CEPHEI and other stars"
        expect(described_class.qcode(sub)).to be_truthy
      end
    end
  end

  describe "#en_wikipedia_url" do
    context "with a valid Wikidata id" do
      let(:wikidata) { described_class.new("Q269848") }

      it "is an en wikipedia url" do
        expect(wikidata.en_wikipedia_url).to(
          start_with("https://en.wikipedia.org/wiki/")
        )
      end
    end

    context "with nil" do
      let(:wikidata) { described_class.new(nil) }

      it "is nil" do
        expect(wikidata.en_wikipedia_url).to be_nil
      end
    end

    context "with a non Wikidata id" do
      let(:wikidata) { described_class.new("blah") }

      it "is nil" do
        expect(wikidata.en_wikipedia_url).to be_nil
      end
    end

    context "with an unknown Wikidata id" do
      let(:wikidata) { described_class.new("Q99999999999999") }

      it "is nil" do
        expect(wikidata.en_wikipedia_url).to be_nil
      end
    end
  end

  describe "#born_in" do
    context "with a valid Wikidata id for a person" do
      let(:wikidata) { described_class.new("Q269848") }

      it "is a year" do
        expect(wikidata.born_in).to match(/\d\d\d\d/)
      end
    end

    context "with nil" do
      let(:wikidata) { described_class.new(nil) }

      it "is nil" do
        expect(wikidata.born_in).to be_nil
      end
    end

    context "with a non Wikidata id" do
      let(:wikidata) { described_class.new("boop") }

      it "is nil" do
        expect(wikidata.born_in).to be_nil
      end
    end

    context "with an unknown Wikidata id" do
      let(:wikidata) { described_class.new("Q2341414123421") }

      it "is nil" do
        expect(wikidata.born_in).to be_nil
      end
    end
  end

  describe "#disambiguation?" do
    context "with a valid Wikidata id for a person" do
      let(:wikidata) { described_class.new("Q269848") }

      it "is not ambiguous" do
        output = wikidata.disambiguation?
        expect(output).to be_falsy
      end
    end

    context "when a Wikidata disambiguation page" do
      let(:wikidata) { described_class.new("Q255563") }

      it "is ambiguous" do
        output = wikidata.disambiguation?
        expect(output).to be_truthy
      end
    end

    context "when nil" do
      let(:wikidata) { described_class.new(nil) }

      it "is not ambiguous" do
        output = wikidata.disambiguation?
        expect(output).to be_falsy
      end
    end

    context "with a non Wikidata id" do
      let(:wikidata) { described_class.new("boop") }

      it "is not ambiguous" do
        output = wikidata.disambiguation?
        expect(output).to be_falsy
      end
    end

    context "with an unknown Wikidata id" do
      let(:wikidata) { described_class.new("Q2341414123421") }

      it "is not ambiguous" do
        output = wikidata.disambiguation?
        expect(output).to be_falsy
      end
    end
  end
end
