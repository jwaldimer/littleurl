FactoryBot.define do
  factory :little_url do
    original_url { "https://example.com/#{SecureRandom.hex(3)}" }
    token        { "token#{SecureRandom.hex(2)}" }
    slug         { token }
    creator_id   { SecureRandom.uuid }
    created_at   { Time.now }
  end
end
