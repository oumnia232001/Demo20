class Post < ApplicationRecord
	has_many :comments, dependent: :destroy
	validates :title, presence: true
  validates :content, presence: true
end
