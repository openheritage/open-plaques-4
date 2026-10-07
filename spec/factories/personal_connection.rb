FactoryBot.define do
  factory :personal_connection do
    association :verb
    person
    plaque
  end
end
