class Note < ApplicationRecord

  has_many :note_contents, dependent: :destroy
  has_many :contents, through: :note_contents

  validates :body, presence: true

  include SearchCop

  search_scope :search do
    attributes(*%i(
      id
      body
      created_at
      updated_at
    ))
  end

end
