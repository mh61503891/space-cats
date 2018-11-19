class ImagesController < ApplicationController

  # GET /images
  def index
    @images = Image.order(updated_at: :desc)
  end

  # GET /images/:image_id/image
  def image
    @image = Image.find_by!(id: params[:image_id])
    send_data(@image.content, disposition: :inline, filename: @image.filename)
  end

end
