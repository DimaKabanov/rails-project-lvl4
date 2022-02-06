class ChangeRepoCreatedAtToBeDatetimeInRepositories < ActiveRecord::Migration[6.1]
  def change
    change_column :repositories, :repo_created_at, :datetime, using: 'repo_created_at::timestamp without time zone'
  end
end
