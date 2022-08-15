class Contents::FetchMetadataService

  def initialize(content)
    @content = content
  end

  def execute!
    uri = Addressable::URI.parse(@content.canonical_url || @content.url)
    if ["twitter.com"].any? { |host| uri.host.include?(host) }
      Contents::FetchMetadataByWebdriverService.new(@content).execute!
    else
      Contents::FetchMetadataByFaradayService.new(@content).execute!
    end
  end

end
