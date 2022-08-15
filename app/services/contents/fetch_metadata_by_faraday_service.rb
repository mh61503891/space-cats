require "openssl"
OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:options] |= OpenSSL::SSL::OP_ALLOW_UNSAFE_LEGACY_RENEGOTIATION

class Contents::FetchMetadataByFaradayService

  def initialize(content)
    @content = content
  end

  def execute!
    uri = Addressable::URI.parse(@content.canonical_url || @content.url)
    page = wget_page(uri)
    check_page_status!(uri, page)
    case detect_content_type(page.content_type)
    when :html; on_html(uri, page)
    when :image; on_image(uri, page)
    else raise "Unsupported Content-Type #{page.content_type}: #{uri}"
    end
  end

  private 

  # @params [Addressable::URI] uri
  # @return [MetaInspector::Document]
  def wget_page(uri)
    MetaInspector.new(uri, allow_non_html_content: true)
  end

  # @params [Addressable::URI] uri
  # @params [MetaInspector::Document] page
  def check_page_status!(uri, page)
    if !page.response.success?
      status = page.response.status
      reason_phrase = page.response.reason_phrase
      raise "#{status} #{reason_phrase}: #{uri}"
    end
  end

  def detect_content_type(content_type)
    return :html if Mime::Type.parse(content_type).any? { |t| t.html? }
    return :image if MIME::Types[content_type].any? { |t| t.media_type == "image" }
    return nil
  end

  # @params [Addressable::URI] uri
  # @params [MetaInspector::Document]
  def on_html(uri, page)
    # TODO
    @content.assign_attributes(page_to_params(page))
    @content.data = page_to_blob(page)
    @content.abstract_data = wget_abstract_blob_from_page(page)
    @content.save!
  end

  # @params [Addressable::URI] uri
  # @params [MetaInspector::Document]
  def on_image(uri, page)
    # TODO
  end

  # @params [MetaInspector::Document] page
  # @return [Hash]
  def page_to_params(page)
    return {
      media_type: "document",
      url: Addressable::URI.parse(page.url),
      canonical_url: Content.canonize(Addressable::URI.parse(page.untracked_url)),
      og_title: page.best_title,
      og_author: page.best_author,
      og_description: page.best_description,
      og_image: Addressable::URI.parse(page.images.best),
      og_type: page.meta.dig("og:type"),
      og_url: page.meta.dig("og:url"),
      og_site_name: page.meta.dig("og:site_name"),
    }.compact
  end

  # @params [MetaInspector::Document] page
  # @return [Blob or NilClass]
  def page_to_blob(page)
    params = {
      filename: Addressable::URI.parse(page.untracked_url).basename,
      content_type: page.content_type,
      checksum: Digest::MD5.base64digest(page.response.body),
      byte_size: page.response.body.size,
      data: page.response.body,
    }.compact
    return Blob.find_by(checksum: params[:checksum]).presence || Blob.new(params)
  end

  # @params [MetaInspector::Document] page
  # @return [Blob or NilClass]
  def wget_abstract_blob_from_page(page)
    page_uri = Content.canonize(Addressable::URI.parse(page.url))
    image_uri = Addressable::URI.parse(page.images.best)
    return case
    when image_uri.blank?
      nil
    when image_uri.ip_based?
      wget_blob(image_uri)
    when image_uri.relative?
      wget_blob(page_uri.join(image_uri))
    else
      raise "Unsupported URL: wget_abstract_blob_from_page(#{page_uri}, #{image_uri})"
    end
  end

  # @params [Addressable::URI] uri
  # @return [Blob or NilClass]
  def wget_blob(uri)
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
