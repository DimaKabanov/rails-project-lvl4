class RenameRepoNameToFullName < ActiveRecord::Migration[6.1]
  def change
    rename_column :repositories, :repo_name, :full_name
  end
end
