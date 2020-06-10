class ReviewsController < ApplicationController

  def new
    @review = Review.new
  end

  def create
    # should we check for merchant_id in this action, or take care of in review validations??
    # rescue ActionController::ParameterMissing
    # redirect_to new_review_path

    if params[:product_id].nil?
      # correct behavior?
      redirect_to root_path, notice: 'Review unable to be created'
      return
    end

    @review = Review.new(review_params)
    @review.product_id = params[:product_id]
  
    if @review.save
      flash[:success] = "Review added successfully"
      redirect_to product_path(params[:product_id])
    else
      # different path???
      redirect_to root_path, notice: 'Problem: Review was not made.'
    end
  end

  private

  def review_params
    return params.require(:review).permit(:content, :rating)
  end
end
