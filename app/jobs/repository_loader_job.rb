# frozen_string_literal: true

class RepositoryLoaderJob < ApplicationJob
  queue_as :default

  def perform(repository_id, check_id, token)
    repository = Repository.find(repository_id)
    github_id = repository.github_id

    client = Octokit::Client.new access_token: token, per_page: 200
    found_repo = client.repos.find { |repo| repo.id == github_id }

    repository.update(
      github_id: found_repo[:id],
      repo_name: found_repo[:full_name],
      clone_url: found_repo[:clone_url],
      language: found_repo[:language].downcase,
      repo_created_at: found_repo[:created_at],
      repo_updated_at: found_repo[:updated_at]
    )

    RepositoryCheckJob.perform_later repository_id, check_id
  end
end
