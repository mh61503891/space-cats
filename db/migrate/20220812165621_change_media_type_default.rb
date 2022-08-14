class ChangeMediaTypeDefault < ActiveRecord::Migration[7.0]
  def change
    change_column_default :contents, :media_type, 0
  end
end
