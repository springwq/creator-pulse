class Content < ApplicationRecord
  belongs_to :creator

  enum :social_media_provider, { instagram: 0, tiktok: 1, youtube: 2 }

  validates :title, presence: true
  validates :social_media_url, presence: true, format: {
    with: /\Ahttps?:\/\/.+\z/i,
    message: "must be a valid URL starting with http:// or https://"
  }
  validates :social_media_provider, inclusion: { in: social_media_providers.keys }
end
