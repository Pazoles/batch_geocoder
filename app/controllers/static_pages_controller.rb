class StaticPagesController < ApplicationController
  def home
    if logged_in?
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
  end
  
    def after_import
    @feed_items = current_user.feed.paginate(page: params[:page])
    render :partial => 'shared/feed'
  end
  
end
