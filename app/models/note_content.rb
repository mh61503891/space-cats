class NoteContent < ApplicationRecord
  belongs_to :note
  belongs_to :content
end
