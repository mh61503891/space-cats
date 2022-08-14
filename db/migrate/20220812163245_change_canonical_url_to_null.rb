class ChangeCanonicalUrlToNull < ActiveRecord::Migration[7.0]
  def change
    change_column_null :contents, :canonical_url, true
  end
end
