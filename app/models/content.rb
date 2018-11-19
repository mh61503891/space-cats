class Content < ApplicationRecord

  enum media_type: { page: 0, image: 1 }

  belongs_to :data, class_name: 'Blob', foreign_key: 'data_id'
  belongs_to :abstract_data, class_name: 'Blob', foreign_key: 'abstract_data_id', optional: true
  has_many :content_keywords
  has_many :keywords, through: :content_keywords

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

  # @params [Addressable::URI] uri
  # @return [Content]
  def self.get(uri)
    content = nil
    content ||= Content.find_by(url: uri.display_uri.to_s)
    content ||= Content.find_by(url: canonize(uri).to_s)
    return content
  end

  # TODO: implements
  # @params [Addressable::URI] uri
  # @return [Addressable::URI]
  def self.canonize(uri)
    uri.normalize!
    if uri.query_values.present?
      query_values = uri.query_values
      # TODO: refactor
      %w[
        utm_campaign
        utm_medium
        utm_source
        utm_content
        fbclid
      ].each do |key|
        query_values.delete(key)
      end
      uri.query_values = query_values.presence
    end
    return uri
  end

  # https://www.slideshare.net from_action

end
