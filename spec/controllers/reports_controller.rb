require 'spec_helper'
describe ReportsController do
  describe 'GET #index' do
    context 'with authorized organizacional user' do
      before(:each) do
        @user = create(:organizacional)
        sign_in @user
      end
      it "renders the index template" do
        get :index
        expect(response).to render_template :index
      end
    end
    context 'with authorized admin user' do
      before(:each) do
        @user = create(:admin)
        sign_in @user
      end
      it "renders the index template" do
        get :index
        expect(response).to render_template :index
      end
    end
    context 'with authorized reader user' do
      before(:each) do
        @user = create(:reader)
        sign_in @user
      end
      it "renders the index template" do
        get :index
        expect(response).to render_template :index
      end
    end
    context 'with unauthorized user' do
      before(:each) do
        @user = create(:user)
        sign_in @user
      end
      it "redirects to dashboard" do
        get :index
        expect(response).to redirect_to dashboard_path
      end
    end
  end
end