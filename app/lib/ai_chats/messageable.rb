# frozen_string_literal: true

module AiChats
  module Messageable
    private

    # It propagates the spinner to the client
    # @param message [String] the message to show in the spinner, if missing only dots are shown
    def show_spinner(message: nil)
      return unless ai_chat

      Turbo::StreamsChannel.broadcast_after_to([ai_chat, "ai_messages"],
                                               target:  "ai_chat_#{ai_chat.id}_messages",
                                               partial: "ai_chats/spinner",
                                               locals:  { message: })
    end

    # It removes the spinner from the client
    def remove_spinner
      Turbo::StreamsChannel.broadcast_remove_to([ai_chat, "ai_messages"],
                                                target: "ai_chat__spinner")
    end

    # It adds a new AI message to the client
    def add_ai_message(ai_message:)
      Turbo::StreamsChannel.broadcast_append_to([ai_chat, "ai_messages"],
                                                target:  "ai_chat_#{ai_chat.id}_messages",
                                                partial: "ai_messages/ai_message",
                                                locals:  { ai_chat: ai_chat, ai_message:,
                                                is_new: true })
    end

    def update_ai_message(ai_message:)
      Turbo::StreamsChannel.broadcast_replace_to([ ai_chat, "ai_messages" ],
                                                 target: "ai_chat--message_#{ai_message.id}",
                                                 partial: "ai_messages/ai_message",
                                                 locals: { ai_chat: ai_chat, ai_message: })
    end

    def update_ai_message_answer(ai_message_id:, answer_chunk:)
      Turbo::StreamsChannel.broadcast_append_to([ai_chat, 'ai_messages'],
                                                 target: "ai_message_#{ai_message_id}_answer",
                                                 content: answer_chunk)
    end

    def notify_error(message:)
      user = ai_chat&.user
      return if user.nil? && ai_chat_id.present? # Prevents error if ai_chat is nil
    
      Turbo::StreamsChannel.broadcast_replace_to(
        [ user, "notifications" ].compact, # Removes nil values
        target: "ai_chat_#{ai_chat&.id || ai_chat_id}_notification",
        partial: "layouts/error_notification",
        locals: { message: }
      )
    end

    # def notify_error(message:)
    #   Turbo::StreamsChannel.broadcast_replace_to([ ai_chat.user, "notifications" ], target: "ai_chat_#{ai_chat&.id || ai_chat_id}_notification", partial: "layouts/error_notification", locals: { message: })
    # end
  end
end
