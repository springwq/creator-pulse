class RemoveDefaultFromContentsSocialMediaProvider < ActiveRecord::Migration[8.1]
  def change
    change_column_default :contents, :social_media_provider, from: 0, to: nil
  end
end
