require "rails_helper"

describe Role, type: :model do
  it "has a valid factory" do
    expect(create :role).to be_valid
  end

  describe "with no content" do
    let(:a_role) { build :role }

    it "is a person" do
      expect(a_role).to be_person
    end

    it "is a type of person" do
      expect(a_role.type).to eq "person"
    end

    it "is not an animal" do
      expect(a_role).not_to be_animal
    end

    it "is not family" do
      expect(a_role).not_to be_family
    end
  end

  describe "a group" do
    let(:a_group) { build :role, name: "friends", role_type: "group" }

    it "is not a person" do
      expect(a_group).not_to be_person
    end
  end

  describe "a person" do
    let(:a_drummer) { build :role, name: "drummer", role_type: "person" }

    it "is a person" do
      expect(a_drummer).to be_person
    end

    it "is not an animal" do
      expect(a_drummer).not_to be_animal
    end

    it "is not (necessarily) family" do
      expect(a_drummer).not_to be_family
    end
  end

  describe "a duck" do
    let(:a_duck) { build :role, name: "duck", role_type: "animal" }

    it "is an animal" do
      expect(a_duck).to be_animal
    end

    it "is not family" do
      expect(a_duck).not_to be_family
    end
  end

  describe "a spouse" do
    let(:a_wife) { build :role, name: "wife", role_type: "spouse" }

    it "is family" do
      expect(a_wife).to be_family
    end

    it "is a relationship" do
      expect(a_wife).to be_relationship
    end
  end

  describe "a brother" do
    let(:a_brother) { build :role, name: "brother" }

    it "is family" do
      expect(a_brother).to be_family
    end
  end

  describe "a vicar" do
    let(:a_vicar) { build :role, name: "vicar" }

    it "is not family" do
      expect(a_vicar).not_to be_family
    end
  end
end
