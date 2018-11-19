class BlobsController < ApplicationController

  # GET /blobs/:id
  def show
    expires_in 1.hour
    @blob = Blob.find_by!(id: params[:id])
    send_data(@blob.data, disposition: :inline, filename: @blob.filename)
  end

  # GET /blobs/blank
  def blank
    expires_in 1.hour
    send_data(Rails.root.join('app', 'assets', 'images', 'blank.png').read, disposition: :inline)
  end

end
