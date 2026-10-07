FactoryBot.define do
  factory :plaque do
    address { FFaker::AddressUK.street_address }
    area
    inscription { "#{FFaker::Name.name} (#{born = FFaker::Time.between(200.years.ago, 100.years.ago).year}-#{born + rand(20..100)}) #{[ 'died', 'lived', 'was born', 'worked' ].sample} here" }
    latitude { FFaker::Geolocation.lat }
    longitude { FFaker::Geolocation.lng }
  end
end
