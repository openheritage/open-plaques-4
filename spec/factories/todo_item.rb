FactoryBot.define do
  factory :todo_item do
    action { %i[ datacapture google_alert transcribe].sample }
    description { FFaker::Lorem.sentence }
    name { FFaker::Color.name }
  end
end
