class NotesController < ApplicationController

  before_action :set_note, only: %i[ show edit update destroy ]

  # GET /notes
  def index
    @notes = Note.all.includes(:note_contents, :contents).order(created_at: :desc)
  end

  # GET /notes/1
  def show
  end

  # GET /notes/new
  def new
    @note = Note.new
  end

  # GET /notes/1/edit
  def edit
  end

  # POST /notes
  def create
    @note = Note.new(note_params)
    if @note.save
      flash.now.notice = "Note was successfully created."
    else
      flash.now.alert = @note.errors.full_messages.join(".")
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /notes/1
  def update
    if @note.update(note_params)
      redirect_to @note, notice: "Note was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /notes/1
  def destroy
    @note.destroy
    flash.now.notice = "Note was successfully destroyed."
  end

  private

  def set_note
    @note = Note.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:body)
  end

end
