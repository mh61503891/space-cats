require "csv"

class Contents::ImportsController < ApplicationController

  def show
    @contents = []
  end

  def create
    @contents = []
    file = params[:file]
    if file.present?
      CSV.foreach(file, headers: true) do |row|
        content = Content.build(row["url"])
        content.assign_attributes(
          created_at: row["created_at"],
          updated_at: row["created_at"],
        )
        if content.new_record?
          content.save
        end
        @contents << content
      end
    end
    render :show
  end

end
