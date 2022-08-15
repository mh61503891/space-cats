class KeywordsController < ApplicationController

  # GET /keywords
  def index
    @keywords = Keyword.order(updated_at: :desc)
  end

  # GET /keywords/:id
  def show
    @keyword = Keyword.find_by!(id: params[:id])
  end
  
  # POST /keywords
  def create
    @keyword = Keyword.find_or_create_by!(name: keyword_params[:name])
    AssignKeywordsService.new.execute
    redirect_to :keywords
  end

  # POST /keywords/assign
  def assign
    AssignKeywordsService.new.execute
    redirect_to :keywords
  end

  # DELETE /keywords/:id
  def destroy
    @keyword = Keyword.find_by(id: params[:id])
    @keyword.destroy
    redirect_to :keywords
  end

  private 

  def keyword_params
    params.require(:keyword).permit(:name)
  end

end
