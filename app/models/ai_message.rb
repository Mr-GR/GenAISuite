# frozen_string_literal: true

class AiMessage < ApplicationRecord
  belongs_to :ai_chat

  validates :prompt, presence: true

  scope :in_context, -> { where(excluded: false) }
end
