require "test_helper"

describe ReviewsController do
  require "test_helper"

  describe Review do
    describe "new" do
      it "" do
        get new_review_path(product_id: Product.first.id)
        assert_response :success
      end
    end

    def create
      @review = Review.create(review_params)
  
      if @review.save
        flash[:success] = "Review successfully added."
        redirect_to product_path(@review.product_id)
        #  TODO: Render status codes
      else
        render :new, status: :bad_request
      end
    end
    describe "create" do
      it "can create a review" do
        assert_difference('Review.count') do
          post new_review_path, params: { review:{ product: 'rx_bar', rate: '5', content: "great"}}
        end
        assert_redirect_to 
      end
    end
  end
  
end
