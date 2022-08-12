class Contents::NotesController < ApplicationController

  # GET /contents/:content_id/notes/new
  def new
    @content = Content.find_by!(id: params[:content_id])
    @note = @content.notes.build
  end

  # POST /contents/:content_id/notes
  def create
    @content = Content.find_by!(id: params[:content_id])
    @note = @content.notes.build(note_params)
    if @content.save
      flash.now.notice = "Note was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # DELETE /contents/:content_id/notes/1
  def destroy
    @note = Note.find_by!(id: params[:id])
    @note.destroy
    flash.now.notice = "Note was successfully destroyed."

    # @content = Content.find_by!(id: params[:content_id])

    # "content_id"=>"27", "id"=>"18"
    # pp '--'
    # pp '--'
    # pp '--'
    # pp '--'
    # pp '--'
    # pp '--'
    # pp params
    # @content = Content.find_by!(id: params[:content_id])
    # @note.destroy
    # redirect_to notes_url, notice: "Note was successfully destroyed."
  end


  private

  def note_params
    params.require(:note).permit(:body)
  end

end
