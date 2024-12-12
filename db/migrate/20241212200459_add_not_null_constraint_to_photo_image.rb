class AddNotNullConstraintToPhotoImage < ActiveRecord::Migration[7.0]
  def change
    change_column_null :photos, :image, false
  end
end
