class CanonizeContentService

  def execute
    # TODO:
    # internet.watch.impress.co.jp ref
    # itunes.apple.com mt
    Content.find_each do |content|
      content.canonical_url = Content.canonize(Addressable::URI.parse(content.canonical_url))
      content.save!
    end
  end

end
