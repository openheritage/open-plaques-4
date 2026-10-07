FactoryBot.define do
  factory :language do
    alpha2 { "dz" }
    name { FFaker::Lorem.word }
  end
end
