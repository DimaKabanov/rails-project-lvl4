class AddLanguageToRepositoryCheck < ActiveRecord::Migration[6.1]
  def change
    add_column :repository_checks, :language, :string
  end
end
