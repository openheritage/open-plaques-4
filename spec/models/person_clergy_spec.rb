require "rails_helper"

describe Person, type: :model do
  let(:a_person) { build :person }
  let(:vicar_role) { build :vicar }
  let(:farmer_role) { build :farmer }

  describe "#clergy?" do
    context "when a person is a vicar" do
      before do
        a_person.roles << vicar_role
      end

      it "they are in the clergy" do
        expect(a_person).to be_clergy
      end
    end

    context "when a person is a farmer" do
      before do
        a_person.roles << farmer_role
      end

      it "they are not in the clergy" do
        expect(a_person).not_to be_clergy
      end
    end

    context "when a person is a farmer who is also a vicar" do
      before do
        a_person.roles << farmer_role
        a_person.roles << vicar_role
      end

      it "they are in the clergy" do
        expect(a_person).to be_clergy
      end
    end
  end
end
