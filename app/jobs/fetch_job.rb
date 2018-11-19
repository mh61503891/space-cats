class FetchJob < ApplicationJob

  queue_as :default

  def perform(*args)
    # TODO: 例外、参照カウント、追加してすでにあれば表示？、追加カウント
    @content = CreateContentService.new.execute(args[0])
    # rescue Faraday::ConnectionFailed => e
    #   pp args
    #   pp @params
    #   pp @content
    #   raise e
  end

end
