class ContentsController < ApplicationController

  # GET /contents
  def index
    @contents = Content.order(updated_at: :desc)
  end

  # POST /contents
  def create
    @query = params[:query]
    if @query.present?
      @contents = Content.search(@query).order(updated_at: :desc)
      render :index
    end
    if params[:url].present?
      @contents = Content.order(updated_at: :desc)
      FetchJob.perform_now(params[:url])
      #render :index
      redirect_to :contents
    end
  end

  # GET /contents/:id
  def show
    @content = Content.find_by!(id: params[:id])
  end

end
