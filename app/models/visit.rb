class Visit < ApplicationRecord
  belongs_to :little_url

  validates :ip_address, presence: true
end
