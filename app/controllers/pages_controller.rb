class PagesController < ApplicationController

  # GET /pages
  def index
    @pages = Page.order(updated_at: :desc)
  end

  # POST /pages
  def create
    if params[:query].present?
      @pages = Page.search(params[:query]).order(updated_at: :desc)
      render :index
    end
    if params[:url].present?
      @pages = Page.order(updated_at: :desc)
      FetchJob.perform_now(params[:url])
      redirect_to :pages
    end
  end

  # GET /pages/id
  def show
    @page = Page.find_by!(id: params[:id])
  end

  # GET /pages/:page_id/image
  def image
    @content = Page.find_by!(id: params[:page_id])
    if @content.best_image_content.present?
      send_data(@content.best_image_content, disposition: :inline)
    else
      send_data(Rails.root.join('app', 'assets', 'images', 'blank.png').read, disposition: :inline)
    end
  end

end
