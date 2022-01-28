# frozen_string_literal: true

class Repository < ApplicationRecord
  belongs_to :user

  validates :link, presence: true
end
