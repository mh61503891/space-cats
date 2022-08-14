class ContentsController < ApplicationController

  before_action :set_contents, only: [:index]
  before_action :set_content, only: [:show]

  # GET /contents
  def index
  end

  # GET /contents/:id
  def show
  end

  # GET /contents/new
  def new
    @content = Content.new
  end

  # POST /contents
  def create
    @content = Content.build(content_params[:url])
    if @content.save
      Contents::FetchMetadataJob.perform_later(@content)
      flash.now.notice = "Content was successfully created."
    else
      flash.now.alert = @content.errors.full_messages.join(".")
      render turbo_stream: turbo_stream.update("flash", partial: "app/flash")
    end
  end

  # PATCH /contents/:id/fetch_metadata
  def fetch_metadata
    @content = Content.find_by!(id: params[:content_id])
    Contents::FetchMetadataJob.perform_later(@content)
  end

  private

  def set_contents
    @contents = Content.order(updated_at: :desc).page(params[:page])
  end

  def set_content
    @content = Content.find_by!(id: params[:id])
  end

  def content_params
    params.require(:content).permit(:url)
  end

end
