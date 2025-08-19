FactoryBot.define do
  factory :visit do
    little_url
    ip_address { "127.0.0.1" }
    user_agent { "Mozilla" }
  end
end
