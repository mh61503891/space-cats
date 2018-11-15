class ContentsController < ApplicationController

  # GET /contents
  def index
    @contents = Content.order(updated_at: :desc)
  end

  # POST /contents
  def create
    uri = Addressable::URI.parse(params[:uri])
    response = Faraday.get(uri)
    open_graph = OGP::OpenGraph.new(response.body)
    args = {
      uri: uri.to_s,
      open_graph_title: open_graph.title&.force_encoding('UTF-8'),
      open_graph_type: open_graph.type,
      open_graph_url: Addressable::URI.parse(open_graph.url).to_s,
      open_graph_image_url: Addressable::URI.parse(open_graph.image.url).to_s,
      open_graph_site_name: open_graph.site_name&.force_encoding('UTF-8'),
      open_graph_description: open_graph.description&.force_encoding('UTF-8'),
    }.compact
    if args[:open_graph_image_url].present?
      args[:open_graph_image_content] = Faraday.get(args[:open_graph_image_url]).body
    end
    @content = Content.new(args)
    if @content.save
      flash[:notice] = 'Saved'
      redirect_to :contents
    else
      render :index
    end
  end

end
