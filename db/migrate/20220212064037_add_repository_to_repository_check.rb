class AddRepositoryToRepositoryCheck < ActiveRecord::Migration[6.1]
  def change
    add_column :repository_checks, :repository, :string
  end
end
