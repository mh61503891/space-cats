class FetchJob < ApplicationJob

  queue_as :default

  def perform(*args)
    url = Addressable::URI.parse(args[0])
    # TODO: count-up if the url exists
    response = Faraday.get(url)
    open_graph = OGP::OpenGraph.new(response.body)
    args = {
      url: url.to_s,
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
    @content = Content.create(args)
    @content.save!
  end

end
