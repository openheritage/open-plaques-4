require "rails_helper"

describe Person, type: :model do
  let(:a_person) { build :person }

  describe "#fill_wikidata_id" do
    context "when an unfindable name" do
      let(:zdfgad) { build :person, name: "zdfgad" }

      before do
        zdfgad.fill_wikidata_id
      end

      it "has no Wikidata" do
        expect(zdfgad.wikidata_id).to be_nil
      end
    end

    context "when an ambiguous name" do
      before do
        a_person.name = "John Smith"
        a_person.wikidata_id = nil
        a_person.fill_wikidata_id
      end

      it "has no Wikidata" do
        expect(a_person.wikidata_id).to be "t"
      end
    end
  end

  describe "#wikipedia_url" do
    context "with no wikidata id" do
      it "has no Wikidata" do
        expect(a_person.wikipedia_url).to be_nil
      end
    end

    context "with a wikidata id" do
      before do
        a_person.wikidata_id = "Q269848"
      end

      it "has a wikipedia url" do
        expect(a_person.wikipedia_url).to eq "https://en.wikipedia.org/wiki/Myra_Hess"
      end
    end
  end

  describe "#dbpedia_abstract" do
    context "with no wikidata id" do
      it "has no dbpedia" do
        expect(a_person.dbpedia_abstract).to be_nil
      end
    end

    context "with a wikidata id" do
      before do
        a_person.wikidata_id = "Q8016"
      end

      it "has a dbpedia abstract" do
        expect(a_person.dbpedia_abstract).to include "Winston Leonard Spencer Churchill"
      end
    end
  end
end
