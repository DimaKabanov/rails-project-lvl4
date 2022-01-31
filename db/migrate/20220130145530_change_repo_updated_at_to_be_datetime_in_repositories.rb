class ChangeRepoUpdatedAtToBeDatetimeInRepositories < ActiveRecord::Migration[6.1]
  def change
    change_column :repositories, :repo_updated_at, :datetime
  end
end
