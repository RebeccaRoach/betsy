require "test_helper"

describe MerchantsController do
  let (:merchants) { merchants(:bikin_bobby) }

  describe "index" do
    it "succeeds when there are merchants" do
      get merchants_path

      must_respond_with :success
    end
  end

  







  
end
