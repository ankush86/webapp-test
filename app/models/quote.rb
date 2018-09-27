class Quote < ApplicationRecord
  validates :title, :content, uniqueness: true
end
