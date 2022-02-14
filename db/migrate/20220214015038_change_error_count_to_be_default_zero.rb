class ChangeErrorCountToBeDefaultZero < ActiveRecord::Migration[6.1]
  def change
    change_column :repository_checks, :error_count, :integer, default: 0
  end
end
