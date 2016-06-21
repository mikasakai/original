class ItemsController < ApplicationController
  before_action :logged_in_user , except: [:show]
  before_action :set_item, only: [:show]

  def new
    if params[:q]
      if params[:q].present?
        response = Item.where("title like '%" + params[:q] + "%'")
      else
        response = Item.all
      end
      @items = []
      @items = response.first(20) if response.present?
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
  
  def edit
    @item = Item.find(params[:id])
  end
  
  def update
       @item = Item.find(params[:id])
    if @item.update(item_params)
      # 保存に成功した場合はトップページへリダイレクト
      redirect_to @item , notice: '投稿内容を編集しました'
    else
      # 保存に失敗した場合は編集画面へ戻す
      render 'edit'
    end
  end
  
   
  
  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    flash[:success] = "投稿を削除しました"
    redirect_to request.referrer || root_url
  end
  
  

  private
  
  def set_item
    @item = Item.find(params[:id])
  end
  
  def item_params
    params.require(:item).permit(:title, :description, :image, :image_cache, :remove_image, :category_id, :url)
  end
end
