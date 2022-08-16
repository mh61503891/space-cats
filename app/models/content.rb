class Content < ApplicationRecord

  enum media_type: { unknown: 0, document: 1, image: 2 }

  belongs_to :data, class_name: "Blob", foreign_key: "data_id", optional: true
  belongs_to :abstract_data, class_name: "Blob", foreign_key: "abstract_data_id", optional: true
  has_many :content_keywords
  has_many :keywords, through: :content_keywords
  has_many :note_contents
  has_many :notes, through: :note_contents

  validates :url, url: true
  validates :canonical_url, url: true

  include SearchCop

  search_scope :search do
    attributes(*%i(
      id
      url
      canonical_url
      media_type
      og_title
      og_type
      og_author
      og_image
      og_url
      og_description
      og_site_name
      input_count
      output_count
      created_at
      updated_at
    ))
  end

  # @params [String] uri
  # @return [Content]
  def self.build(uri)
    uri = Addressable::URI.parse(uri)
    content = nil
    content ||= Content.find_by(url: uri.display_uri.to_s)
    content ||= Content.find_by(url: canonize(uri).to_s)
    if content.present?
      content.input_count += 1
    else
      content = Content.new(
        url: uri.display_uri.to_s,
        canonical_url: canonize(uri).to_s,
      )
    end
    return content
  end

  # @params [Addressable::URI] uri
  # @return [Addressable::URI]
  def self.canonize(uri)
    uri.normalize!
    if uri.query_values.present?
      query_values = uri.query_values
      # @see MetaInspector::URL::WELL_KNOWN_TRACKING_PARAMS
      %w[
        utm_source
        utm_medium
        utm_term
        utm_content
        utm_campaign
        fbclid
        gclid
        yclid
      ].each do |key|
        query_values.delete(key)
      end
      uri.query_values = query_values.presence
    end
    # TODO refactor
    # for Amazon
    if uri.host == "www.amazon.co.jp"
      uri.path = uri.path.scan(/\/dp\/[A-Z0-9]{10}/).first
    end
    return uri
  end

  def fetch_metadata!
    Contents::FetchMetadataService.new(self).execute!
  end

end
