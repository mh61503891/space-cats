class Note < ApplicationRecord
  has_many :note_contents, dependent: :destroy
  has_many :contents, through: :note_contents
end
