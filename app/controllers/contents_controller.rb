class ContentsController < ApplicationController

  before_action :set_contents, only: [:index, :create]
  before_action :set_content, only: [:show]

  # GET /contents
  def index
  end

  # POST /contents
  def create
    @query = params[:query]
    if @query.present?
      render :index
    end
    if params[:url].present?
      FetchJob.perform_now(params[:url])
      redirect_to :contents
    end
  end

  # GET /contents/:id
  def show
    set_content
  end

  private

    def set_contents
      if params[:query].present?
        @contents = Content.search(params[:query]).order(updated_at: :desc).page
      else
        @contents = Content.order(updated_at: :desc).page
      end
    end

    def set_content
      @content = Content.find_by!(id: params[:id])
    end

end
