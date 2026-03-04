class Creator < ApplicationRecord
  has_many :contents, dependent: :destroy

  validates :name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }

  scope :ordered_by_name, -> { order(:name) }
  scope :with_content_count, -> {
    left_joins(:contents)
      .select("creators.*, COUNT(contents.id) AS content_count")
      .group("creators.id")
  }
  scope :search_by_name, ->(query) { where("name ILIKE ?", "%#{sanitize_sql_like(query)}%") if query.present? }
end
