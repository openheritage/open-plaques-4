FactoryBot.define do
  factory :series do
    description { FFaker::CheesyLingo.sentence }
    name { FFaker::CheesyLingo.words(3).join(" ") }
  end
end
