# frozen_string_literal: true

class Repository < ApplicationRecord
  extend Enumerize

  belongs_to :user
  has_many :checks, class_name: 'Repository::Check', dependent: :destroy

  validates :github_id, presence: true

  enumerize :language, in: %i[javascript ruby]

  def self.client_repos(user_token, user_id)
    Rails.cache.fetch([user_id, :client_repositories]) do
      repository_api = ApplicationContainer[:repository_api]
      available_languages = self.language.values
      client = repository_api.client(user_token)
      client_repositories = repository_api.get_repositories(client)
      client_repositories
        .select { |repo| repo[:language].present? }
        .filter { |repo| available_languages.include? repo[:language].downcase }
        .map { |repo| [repo[:full_name], repo[:id]] }
    end
  end

  def self.invalidate_repos_cache(user_id)
    Rails.cache.delete([user_id, :client_repositories])
 end
end
