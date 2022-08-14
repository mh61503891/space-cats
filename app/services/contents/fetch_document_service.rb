class Contents::FetchDocumentService

  # @params [Content] content
  # @params [Addressable::URI] uri
  # @params [MetaInspector::Document] resource
  def initialize(content:, uri:, resource:)
    @content = content
    @uri = uri
    @resource = resource
  end

  def execute!
    @content.assign_attributes(get_content_params(@resource))
    @content.data = get_content_data(@resource)
    @content.abstract_data = get_content_abstract_data(@resource)
    @content.save!
  end

  private

  # @params [MetaInspector::Document] resource
  # @return [Hash]
  def get_content_params(resource)
    return {
      media_type: "document",
      url: Addressable::URI.parse(resource.url),
      canonical_url: Content.canonize(Addressable::URI.parse(resource.untracked_url)),
      og_title: resource.best_title,
      og_type: resource.meta.dig("og:type"),
      og_author: resource.best_author,
      og_image:  Addressable::URI.parse(resource.images.best),
      og_url: resource.meta.dig("og:url"),
      og_description: resource.best_description,
      og_site_name: resource.meta.dig("og:site_name"),
    }.compact
  end

  # @params [MetaInspector::Document] resource
  # @return [Blob or NilClass]
  def get_content_data(resource)
    if !resource.response.success?
      return nil
    else
      params = {
        filename: Addressable::URI.parse(resource.untracked_url).basename,
        content_type: resource.content_type,
        checksum: Digest::MD5.base64digest(resource.response.body),
        byte_size: resource.response.body.size,
        data: resource.response.body,
      }.compact
      return Blob.find_by(checksum: params[:checksum]).presence || Blob.new(params)
    end
  end

  # @params [MetaInspector::Document] resource
  # @return [Blob or NilClass]
  def get_content_abstract_data(resource)
    page_url = Content.canonize(Addressable::URI.parse(resource.url))
    image_url = Addressable::URI.parse(resource.images.best)
    get_image_data(page_url, image_url)
  end

  # @params [Addressable::URI] page_uri
  # @params [Addressable::URI] image_uri
  # @return [Blob or NilClass]
  def get_image_data(page_uri, image_uri)
    if image_uri.blank?
      return nil
    elsif image_uri.ip_based?
      get_data(image_uri)
    elsif image_uri.relative?
      get_data(page_uri.join(image_uri))
    else
      raise "Unsupported URL: wget_image(#{page_uri}, #{image_uri})"
    end
  end

  # @params [Addressable::URI] uri
  # @return [Blob or NilClass]
  def get_data(uri)
    res = Faraday.get(uri.normalize)
    if !res.success? || res.body.blank?
      return nil
    else
      params = {
        filename: Addressable::URI.parse(res.env.url).basename,
        content_type: res.headers["content-type"].presence&.split(";")&.first,
        checksum: Digest::MD5.base64digest(res.body),
        byte_size: res.body.size,
        data: res.body,
      }.compact
      return Blob.find_by(checksum: params[:checksum]).presence || Blob.new(params)
      end
  end

end
