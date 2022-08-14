class Contents::FetchMetadataJob < ApplicationJob

  queue_as :default

  def perform(content)
    content.fetch_metadata!
    content.broadcast_prepend_later_to(
      "flashes",
      target: "flashes",
      partial: "app/flash",
      locals: { notice: "Fetch Metadata succeeded." }
    )
    content.broadcast_prepend_later_to("contents")
    content.broadcast_update_later_to(
      "content",
      partial: "contents/content_detail"
    )
  rescue => e
    Rails.logger.info(e)
    Rails.logger.info(e.backtrace.join("\n"))
    content.broadcast_update_to(
      "flashes",
      target: "flashes",
      partial: "app/flash",
      locals: { alert: "Fetch Metadata failed." }
    )
  rescue Exception => e
    Rails.logger.error(e)
    Rails.logger.error(e.backtrace.join("\n"))
    content.broadcast_prepend_to(
      "flashes",
      target: "flashes",
      partial: "app/flash",
      locals: { alert: "Fetch Metadata failed." }
    )
  end

end
