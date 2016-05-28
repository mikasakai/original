class ItemsController < ApplicationController
  before_action :logged_in_user , except: [:show]
  before_action :set_item, only: [:show]

  def new
    if params[:q]
      response = RakutenWebService::Ichiba::Item.search(
        keyword: params[:q],
        imageFlag: 1,
      )
      @items = response.first(20)
    end
  end

  def show
    @want_users = @item.want_users
    @have_users = @item.have_users
  end
  
  def post
    @item = Item.new
  end
  
  def create
    @item = Item.new(item_params)
    if @item.save
      current_user.have(@item)
      redirect_to current_user, notice: "投稿が完了しました"
    else
      render 'new'
    end
  end

  private
  
  def set_item
    @item = Item.find(params[:id])
  end
  
  def item_params
    params.require(:item).permit(:title, :description)
  end
end
