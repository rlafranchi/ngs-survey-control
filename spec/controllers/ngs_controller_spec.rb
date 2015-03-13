require 'rails_helper'

describe NgsController do
  describe "GET #index" do
    it "renders index template" do
      get :index
      expect(response).to render_template :index
    end
  end
end