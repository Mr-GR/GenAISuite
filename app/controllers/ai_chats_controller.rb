class AiChatsController < PrivateController
  before_action :set_ai_chat, only: [ :show, :ask]

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

  # Post /ai/create
  def create
    @ai_chat = AiChat.build(user_id: current_user.id,
                            ai_model_name: ask_params[:ai_model_name].presence || CreateAiChatMessageService::DEFAULT_MODEL_NAME,
                            title: ask_params[:prompt].truncate(100))

    respond_to do |format|
      if @ai_chat.save
        CreateAiChatMessageJob.set(wait: 0.5.seconds).perform_later(ask_params[:prompt], @ai_chat.id)

        message = "Chat created, please wait for a response."

        format.html { redirect_to(ai_chat_url(@ai_chat), notice: message) }
        format.json { render(:show, status: :created, location: @ai_chat) }
      else
        format.html { render(:new, status: :unprocessable_entity) }
        format.json { render(json: @ai_chat.errors, status: :unprocessable_entity) }
      end
    end
  end

  def ask
    return(head :no_content) if ask_params[:prompt].blank?

    CreateAiChatMessageJob.set(wait: 0.5.seconds).perform_later(ask_params[:prompt], @ai_chat.id)
  end 
  
  private 

  attr_reader :ai_chat

  def set_ai_chat
    @ai_chat = current_user.ai_chats.includes(:ai_messages).find(params[:id])
  end

  def ask_params
    params.permit(:prompt, :ai_model_name)
  end
end
