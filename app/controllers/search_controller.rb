class SearchController < ApplicationController

  # GET /search
  # POST /search
  def index
    @query = params[:query]
    @contents = []
    @keywords = []
    if @query.present?
      @contents = Content.search(@query).order(updated_at: :desc)
      @keywords = Keyword.search(@query).order(updated_at: :desc)
    end
    render :index
  end

end
