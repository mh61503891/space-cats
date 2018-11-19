class AssignKeywordsService

  def execute
    Keyword.find_each do |keyword|
      Content.search(keyword.name).each do |content|
        ContentKeyword.find_or_create_by!(
          content_id: content.id,
          keyword_id: keyword.id,
        )
      end
    end
  end

end
