class RemoveRepoUpdatedAtFromRepositories < ActiveRecord::Migration[6.1]
  def change
    remove_column :repositories, :repo_updated_at, :datetime
  end
end
