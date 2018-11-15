class ContentsController < ApplicationController

  # GET /contents
  def index
    @contents = Content.order(updated_at: :desc)
  end

  # POST /contents
  def create
    FetchJob.perform_later(params[:url])
    redirect_to :contents
  end

end
