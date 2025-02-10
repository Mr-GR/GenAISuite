# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "AiChats", type: :request do
  describe "GET /index" do
    let(:action) { -> { get "/ai" } }

    context 'when user is not logged in' do
      it 'redirects to the login page' do
        action.call
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context 'when user is logged in' do
      let(:user) { create(:user) }

      before do
        login_as user
      end

      it 'returns http success' do
        action.call
        expect(response).to have_http_status(:success)
      end

      it 'renders the index template' do
        action.call
        expect(response).to render_template(:index)
      end

      context 'when there are NO chats' do
        it 'assigns an empty array to @ai_chats' do
          action.call
          expect(assigns(:ai_chats)).to eq([])
        end
      end

      context 'when there are chats' do
        let!(:ai_chat) { create(:ai_chat, user:) }

        it 'assigns an array to @ai_chats' do
          action.call
          expect(assigns(:ai_chats)).to eq([ai_chat])
        end
      end
    end
  end
end
