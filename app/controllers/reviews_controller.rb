class ReviewsController < ApplicationController
  before_action :authorize_user, except: [:index, :show]

  def edit
    @review = Review.find(params[:id])
  end

  def create
    @item = Item.find(params[:item_id])
    @user = User.find(current_user.id)
    @review = Review.new(reviews_params)
    @review.item = @item
    @review.user = @user

    if @review.save
      redirect_to item_path(@item), notice: 'Review was successfully posted.'
    else
      render '/items/show'
    end
  end

  def update
    @review = Review.find(params[:id])
    if @review.update(reviews_params)
      @item = @review.item
      redirect_to @item, notice: 'Review was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @review = Review.find(params[:id])
    @item = @review.item
    @review.destroy
    redirect_to @item, notice: 'Review was successfully deleted.'
  end

  private
  def reviews_params
    params.require(:review).permit(:rating, :body)
  end

  def authorize_user
    if !user_signed_in?
      flash[:notice] = "Sign in required before proceeding."
      redirect_to root_path
    end
  end

end
