class ReviewsController < ApplicationController
  def new
    @review = Review.new
    @product_id = params[:product_id]
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

  private

  def review_params1
    return params.require(:review).permit(:content, :rating, :product_id)
  end
end
