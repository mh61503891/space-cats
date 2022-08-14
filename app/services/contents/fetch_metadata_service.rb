require "openssl"
OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:options] |= OpenSSL::SSL::OP_ALLOW_UNSAFE_LEGACY_RENEGOTIATION

class Contents::FetchMetadataService

  def initialize(content)
    @content = content
  end

  def execute!
    uri = Addressable::URI.parse(@content.canonical_url || @content.url)
    resource = MetaInspector.new(uri, allow_non_html_content: true)
    if resource.response.success?
      if resource.content_type.present?
        if Mime::Type.parse(resource.content_type).any? { |t| t.html? }
          onHTML!(@content, uri, resource)
        elsif MIME::Types[resource.content_type].any? { |t| t.media_type == "image" }
          onImage!(@content, uri, resource)
        else
          # TODO: using ruby-filemagic and shared-mime-info
          raise "Unsupported Content-Type #{resource.content_type}: #{uri}"
        end
      else
        # TODO: using ruby-filemagic and shared-mime-info
        raise "Content-Type does not present: #{uri}"
      end
    else
      status = resource.response.status
      reason_phrase = resource.response.reason_phrase
      raise "#{status} #{reason_phrase}: #{uri}"
    end
  end

  private

  def onHTML!(content, uri, resource)
    Contents::FetchDocumentService.new(
      content: content,
      uri: uri,
      resource: resource,
    ).execute!
  end

  def onImage!(content, uri, resource)
    raise NotImplementedError
    # Contents::FetchImageService.new(
    #   content: @content,
    #   resource: resource,
    # ).execute!
  end

end
