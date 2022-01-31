class RenameLinkToGithubId < ActiveRecord::Migration[6.1]
  def change
    rename_column :repositories, :link, :github_id
  end
end
