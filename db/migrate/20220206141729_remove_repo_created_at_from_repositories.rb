class RemoveRepoCreatedAtFromRepositories < ActiveRecord::Migration[6.1]
  def change
    remove_column :repositories, :repo_created_at, :datetime
  end
end
