class LittleUrl < ApplicationRecord
  has_many :visits, dependent: :destroy

  extend FriendlyId
  friendly_id :token, use: :slugged

  VALID_TOKEN_REGEX = /\A(?!.*\s)[a-zA-Z0-9\-_]+\z/
  RESERVED_TOKENS = %w[api admin login logout users user new edit show token]
  CREATE_PARAMS = %i[original_url token description]

  validates :original_url, presence: true, format: URI::DEFAULT_PARSER.make_regexp
  validate  :original_url_must_be_valid
  validates :token, presence: true, uniqueness: true,
                    format: { with: VALID_TOKEN_REGEX },
                    length: { maximum: 50 }
  validates :creator_id, presence: true
  validate :token_not_reserved

  private

  def token_not_reserved
    return unless RESERVED_TOKENS.include?(token&.downcase)
    errors.add(:token, I18n.t("little_url.errors.token_reserved"))
  end

  def original_url_must_be_valid
    uri = URI(original_url)
    return if (uri && %w[http https].include?(uri.scheme) && uri.host.present?)
    errors.add(:original_url, I18n.t("little_url.errors.must_be_valid"))
  rescue
    errors.add(:original_url, I18n.t("little_url.errors.must_be_valid"))
  end

  def should_generate_new_friendly_id?
    token_changed? || super
  end
end
