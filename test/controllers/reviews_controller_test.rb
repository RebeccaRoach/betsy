require "test_helper"

describe ReviewsController do
  require "test_helper"

  describe Review do
    describe "new" do
      it "successfully retrieve new review page for valid product id" do
        get new_review_path(product_id: Product.first.id)
        must_respond_with :success
      end
    end

    describe "create" do
      let(:product) { products(:rx_bar) }
      it "can create a valid review and redirects to product page" do
        valid_hash = {
          review: {
            rating: 5,
            product_id: product.id
          },
        } 

        assert_difference("Review.count") do
          post reviews_path(product.id), params: valid_hash 
        end

        new_review = Review.last
        
        expect(new_review.rating).must_equal 5
        expect(new_review.product_id).must_equal products(:rx_bar).id
        expect
        
        must_redirect_to product_path(products(:rx_bar).id)
      end
    end
    # describe "review_params" do
    # end
  end
  
end
