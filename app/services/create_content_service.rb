require "openssl"
OpenSSL::SSL::SSLContext::DEFAULT_PARAMS[:options] |= OpenSSL::SSL::OP_ALLOW_UNSAFE_LEGACY_RENEGOTIATION

class CreateContentService

  def execute(uri)
    uri = Addressable::URI.parse(uri)
    content = Content.get(uri)
    if content.present?
      content.input_count += 1
      content.save!
      # TODO: countup
      return content
    end
    content = MetaInspector.new(uri, allow_non_html_content: true, faraday_options: {ssl: {verify: false}})
    if content.response.success?
      if content.content_type.present?
        if Mime::Type.parse(content.content_type).any?{ |t| t.html? }
          return CreatePageService.new(content).execute
        elsif MIME::Types[content.content_type].any?{ |t| t.media_type == 'image' }
          return CreateImageService.new(content).execute
        else
          # TODO: ruby-filemagic and shared-mime-info
          raise "Unsupported Content-Type #{content_type}: #{uri}"
        end
      else
        # TODO: ruby-filemagic and shared-mime-info
        raise "Content-Type does not present: #{uri}"
      end
    else
      status = content.response.status
      reason_phrase = content.response.reason_phrase
      raise "#{status} #{reason_phrase}: #{uri}"
    end
  end

end
