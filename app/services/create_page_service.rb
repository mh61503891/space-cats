class CreatePageService

  # @params [MetaInspector::Document] page
  def initialize(page)
    @page = page
  end

  def execute
    params = content_params(@page)
    content = Content.new(params)
    content.data = document_to_data(@page)
    content.abstract_data = document_to_data(fetch_image(params))
    content.save!
  end

  private

    # @params [MetaInspector::Document] page
    # @return [Hash]
    def content_params(page)
      return {
        media_type: 'document',
        url: Addressable::URI.parse(page.url),
        canonical_url: Content.canonize(Addressable::URI.parse(page.url)),
        og_title: page.best_title,
        og_type: page.meta.dig('og:type'),
        og_author: page.best_author,
        og_image:  Addressable::URI.parse(page.images.best),
        og_url: page.meta.dig('og:url'),
        og_description: page.best_description,
        og_site_name: page.meta.dig('og:site_name'),
      }.compact
    end

    # @params [Hash] params
    # @return [MetaInspector::Document or NilClass]
    def fetch_image(params)
      return wget_image(params[:canonical_url], params[:og_image])
    end

    # @params [MetaInspector::Document] document
    # @return [Blob or NilClass]
    def document_to_data(document)
      if document.blank? || !document.response.success?
        return nil
      else
        params = document_to_params(document)
        return Blob.find_by(checksum: params[:checksum]).presence || Blob.new(params)
      end
    end

    # @params [MetaInspector::Document] document
    # @return [Hash]
    def document_to_params(document)
      {
        filename: Addressable::URI.parse(document.url).basename,
        content_type: document.content_type,
        checksum: Digest::MD5.base64digest(document.response.body),
        byte_size: document.response.body.size,
        data: document.response.body,
      }.compact
    end

    # @params [Addressable::URI] root_uri
    # @params [Addressable::URI] uri
    # @return [MetaInspector::Document or NilClass]
    # @raise RuntimeError
    def wget_image(root_uri, uri)
      if uri.blank?
        return nil
      elsif uri.ip_based?
        wget(uri)
      elsif uri.relative?
        wget(root_uri.join(uri))
      else
        raise "Unsupported URL: wget_image(#{root_uri}, #{uri})"
      end
    end

    # @param [Addressable::URI] uri
    # @return [MetaInspector::Document]
    def wget(uri)
      ImageInspectorDocument.new(uri)
    end

end

# @see MetaInspector::Document
# @note https://techcommunity.microsoft.com/t5/Identity-Standards-Blog/All-about-FIDO2-CTAP2-and-WebAuthn/ba-p/288910 contains imaegs which is provided with a HTTP response including Content-Type `image/png;charset=UTF-8`. Because the faraday-encoding.gem try to encode binary data as UTF-8, respons.body.tr causes a ArgumentError: invalid byte sequence in UTF-8.
class ImageInspectorDocument

  attr_reader :url, :response

  def initialize(url)
    @url = url
    @response = Faraday.get(@url)
  end

  def content_type
   return nil if response.headers['content-type'].nil?
   response.headers['content-type'].split(';')[0] if response
  end

end
