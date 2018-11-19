class Keyword < ApplicationRecord
  has_ancestry
  has_many :content_keywords, dependent: :destroy
  has_many :contents, through: :content_keywords
end
