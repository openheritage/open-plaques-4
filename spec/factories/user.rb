FactoryBot.define do
  factory :user do
    email { "sdfdfg@sdfs.com" }
    is_admin { true }
    password { FFaker::Lorem.word }
    username { FFaker::Lorem.word }
  end
end
