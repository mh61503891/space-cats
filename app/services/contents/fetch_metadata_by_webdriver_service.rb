require "selenium-webdriver"
require "webdrivers/chromedriver"

class Contents::FetchMetadataByWebdriverService

  # TODO refactor
  USER_AGENT = "Mozilla/5.0 (iPhone; U; CPU iPhone OS 12_1_2 like Mac OS X; ja-jp) AppleWebKit/605.1.15 (KHTML,like Gecko) Version/12.0 Mobile/15E148Safari/604.1"
  # TODO refactor
  SLEEP_SEC = 5

  def initialize(content)
    @content = content
  end

  def execute!
    uri = Addressable::URI.parse(@content.canonical_url || @content.url)
    document = wget_document(uri)
    @content.assign_attributes(document_to_params(uri, document))
    @content.data = document_to_blob(uri, document)
    @content.abstract_data = wget_abstract_blob_from_document(uri, document)
    @content.save!
  end

  private

  # @params [Addressable::URI] uri
  # @return [String]
  def wget_document(uri)
    options = Selenium::WebDriver::Chrome::Options.new
    options.add_argument("--headless")
    options.add_argument("--lang=ja")
    options.add_argument("--user-agent=#{USER_AGENT}")
    driver = Selenium::WebDriver.for(:chrome, options: options)
    driver.get(uri.normalize.to_s)
    sleep(SLEEP_SEC)
    return driver.page_source
  end

  # @params [Addressable::URI] uri
  # @params [String] document
  # @return [Hash]
  def document_to_params(uri, document)
    page = MetaInspector.new(uri, document: document)
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

  # @params [Addressable::URI] uri
  # @params [String] document
  # @return [Blob]
  def document_to_blob(uri, document)
    params = {
      filename: Addressable::URI.parse(uri).basename,
      content_type: Marcel::MimeType.for(document),
      checksum: Digest::MD5.base64digest(document),
      byte_size: document.size,
      data: document,
    }.compact
    return Blob.find_by(checksum: params[:checksum]).presence || Blob.new(params)
  end

  # @params [Addressable::URI] uri
  # @params [String] document
  # @return [Blob]
  def wget_abstract_blob_from_document(uri, document)
    page = MetaInspector.new(uri, document: document)
    wget_abstract_blob_from_page(page)
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
