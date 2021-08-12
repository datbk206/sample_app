class Micropost < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  delegate :name, to: :user, prefix: true

  POST_ATTRS = %i(content image).freeze

  validates :user_id, presence: true
  validates :content, presence: true, length: {
    maximum: Settings.content.max_size
  }
  validates :image, content_type: {
    in: Settings.micropost.img_type,
    message: I18n.t("micropost.invalid_format")
  },
  size: {
    less_than: Settings.micropost.size.megabytes,
    message: I18n.t("micropost.require_size")
  }
  scope :newest, ->{order(created_at: :desc)}
  scope :by_user_id, ->(ids){where user_id: ids}

  def display_image
    image.variant resize: Settings.micropost.image_size
  end
end
