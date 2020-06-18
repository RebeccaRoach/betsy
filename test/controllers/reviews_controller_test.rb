require "test_helper"

describe ReviewsController do
  require "test_helper"

  describe Review do
    describe "new" do
      it "" do
        get new_review_path(product_id: Product.first.id)
        must_respond_with :success
      end
    end
    describe "create" do
      it "can create a valid review and redirects to product page" do
        valid_hash = {
          review: {
            rating: 5,
            product: products(:rx_bar)
          },
        }
        expect {
          post reviews_path(product_id: products(:rx_bar).id), params: valid_hash
        }.must_change "Review.count", 1
        
        new_review = Review.last
        
        expect(new_review.rating).must_equal 5
        expect(new_review.text_review).must_be_nil
        expect(new_review.product_id).must_equal products(:rx_bar).id
        
        must_redirect_to product_path(id: products(:rx_bar).id)
      end
    end
    describe "review_params" do
    end
  end
  
end
