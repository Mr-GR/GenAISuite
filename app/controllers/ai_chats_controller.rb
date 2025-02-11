class AiChatsController < PrivateController
  before_action :set_ai_chat, only: [ :show ]

  #Get /ai
  def index
    @ai_chats = current_user.ai_chats.order(created_at: :desc)
  end

  #Get /ai/:id 
  def show; end 

  #Get /ai/new
  def new 
    @ai_chat = current_user.ai_chats.build
  end

  private 

  attr_reader :ai_chat

  def set_ai_chat
    @ai_chat = current_user.ai_chats.includes(:ai_messages).find(params[:id])
  end
end
