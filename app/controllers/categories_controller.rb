class CategoriesController < ApplicationController

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      # flash[:status] = :success
      # flash[:result_text] = "Successfully created #{@media_category.singularize} #{@work.id}"
      # redirect_to root
    else
      flash[:result_text] = "Could not create category"
    end
  end

  def show
  end
end
