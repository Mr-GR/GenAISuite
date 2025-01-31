require "rails_helper"

RSpec.describe "Homes", type: :request do
  describe "GET /" do
    it "returns http sucess" do
      get "/"
      expect(response).to have_http_status(:success)
    end

    it "renders the home page" do
      get "/"
      expect(response.body).to include("GenAI Suite")
    end
  end
end
