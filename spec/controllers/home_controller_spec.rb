require 'spec_helper'

describe HomeController do

  describe "GET 'dashboard'" do
  	before (:each) do
      @user = create(:user)
      sign_in  @user
    end
    it "returns http success" do
      get 'dashboard'
      response.should be_success
    end
  end

end
