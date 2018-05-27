class ItemsController < ApplicationController
  before_action :authorize_user, except: [:index, :show]

  def index
    @items = Item.order(created_at: :desc)
  end

  def show
    @item = Item.find(params[:id])
    # Following line is required, otherwise, ActionView::Template::Error:
    #   First argument in form cannot contain nil or be empty
    @review = @item.reviews.build(params[:review])
  end

  def new
    @item = Item.new
  end

  def edit
    @item = Item.find(params[:id])
  end

  def create
    @user = User.find(current_user.id)
    @item = Item.new(items_params)
    @item.user = @user
    if @item.save
      redirect_to @item, notice: 'Item was successfully added.'
    else
      render 'new'
    end
  end

  def update
    @item = Item.find(params[:id])
    if @item.update(items_params)
      redirect_to @item, notice: 'Item was successfully updated.'
    else
      render 'edit'
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    redirect_to items_path
  end

  private
  def items_params
    params.require(:item).permit(:name, :description, :item_website)
  end

  def authorize_user
    if !user_signed_in?
      flash[:notice] = "Sign in required before proceeding."
      redirect_to root_path
    end
  end

end
