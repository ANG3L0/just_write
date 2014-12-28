class Article < ActiveRecord::Base
  belongs_to :user
	validates :user_id, presence: true
	validates :title, presence: true, length: { maximum: 140 }
	validates :content, presence: true
	scope :draft, -> { where(draft: true) }
	scope :draft_and_in_order, -> { draft.order(updated_at: :desc) }
	scope :published, -> { where(draft: false) }
	scope :published_and_in_order, -> { published.order(updated_at: :desc) }
	default_scope -> { order(updated_at: :desc) } #used for integration test mainly
end
