# frozen_string_literal: true

module AiChatsHelper
    def markdown(text)
      @markdown ||= AiChats::Markdown.new
      raw(@markdown.render(text).html_safe)
    end
  end
  