class ChangeRepoCreatedAtToBeDatetimeInRepositories < ActiveRecord::Migration[6.1]
  def change
    change_column :repositories, :repo_created_at, :datetime
  end
end
