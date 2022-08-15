class Keyword < ApplicationRecord

  has_ancestry
  has_many :content_keywords, dependent: :destroy
  has_many :contents, through: :content_keywords

  include SearchCop

  search_scope :search do
    attributes(*%i(
      id
      name
      created_at
      updated_at
    ))
  end

end
