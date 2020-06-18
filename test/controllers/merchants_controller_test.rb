require "test_helper"

describe MerchantsController do

  describe "index action" do
    it "repsonds with success" do
      get merchants_path

      must_respond_with :success
    end
  end

  describe 'show action' do
    it 'responds with a success when id given exists' do

      get merchants_path((:id))
      must_respond_with :success
    end
  end

  describe "create with build_from_github" do
    it "returns a merchant" do

      auth_hash = {
        uid: 123,
        info: {
          email: "email@mail.com",
          username: "randomname",
        }
      }
      merchant = Merchant.build_from_github(auth_hash)

      merchant.must_be_kind_of Merchant
      expect(merchant.uid).must_equal auth_hash[:uid]
      expect(merchant.provider).must_equal "github"
      expect(merchant.email).must_equal auth_hash[:info][:email]
      expect(merchant.username).must_equal auth_hash[:info][:username]
    end
  end

  describe "logout" do
    it "logs a merchant out of their session when they click logout" do
      post logout_path
      expect(flash[:result_text]).must_equal "Successfully logged out"
      must_respond_with :redirect
      must_redirect_to root_path
    end
  end

  describe "current" do
    it "responds with success when a current merchant is selected" do
      get merchants_path
      must_respond_with :success
    end
  end
end

