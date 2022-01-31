class ChangeGithubIdToBeIntegerInRepositories < ActiveRecord::Migration[6.1]
  def change
    change_column :repositories, :github_id, :integer
  end
end
