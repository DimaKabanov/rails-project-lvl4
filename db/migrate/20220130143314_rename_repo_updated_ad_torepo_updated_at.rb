class RenameRepoUpdatedAdTorepoUpdatedAt < ActiveRecord::Migration[6.1]
  def change
    rename_column :repositories, :repo_updated_ad, :repo_updated_at
  end
end
