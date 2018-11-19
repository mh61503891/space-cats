class KeywordsController < ApplicationController

  # GET /keywords
  def index
    @keywords = Keyword.order(updated_at: :desc)
  end

  # POST /keywords
  def create
    @query = params[:query]
    if @query.present?
      @keywords = Keyword.search(@query).order(updated_at: :desc)
      render :index
    end
    if params[:keyword].present?
      @keywords = Keyword.order(updated_at: :desc)
      @keyword = Keyword.find_or_create_by!(name: params[:keyword])
      AssignKeywordsService.new.execute
      redirect_to :keywords
    end
  end

  # GET /keywords/:id
  def show
    @keyword = Keyword.find_by!(id: params[:id])
  end

  # POST /keywords/assign
  def assign
    AssignKeywordsService.new.execute
    redirect_to :keywords
  end

  def destroy
    @keyword = Keyword.find_by(id: params[:id])
    # @keyword.content_keywords.destroy
    @keyword.destroy
    redirect_to :keywords
  end

end
