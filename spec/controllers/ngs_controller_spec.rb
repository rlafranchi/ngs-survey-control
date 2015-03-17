require 'rails_helper'

describe NgsController do
  describe "GET #index" do
    it "renders index template" do
      get :index
      expect(response).to render_template :index
    end
    it "sets results when params are set", :vcr do
      get :index, latitude: 40, longitude: -105, distance: 5
      expect(assigns(:results)).to be_present
    end
  end
end
