class Contents::FetchImageService

  def initialize(content:, resource:)
    @content = content
    @resource = resource
  end

  def execute
    raise NotImplementedError
  end

end
