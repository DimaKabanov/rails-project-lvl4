# frozen_string_literal: true

class UpdateInfoRepositoryJob < ApplicationJob
  include Rails.application.routes.url_helpers

  queue_as :default

  def perform(repository)
    repository_api = ApplicationContainer[:repository_api].new(repository.user.token)
    github_id = repository.github_id.to_i

    found_repo = repository_api.repository(github_id)

    repository.update(
      full_name: found_repo[:full_name],
      name: found_repo[:name],
      clone_url: found_repo[:clone_url],
      language: found_repo[:language].downcase
    )

    CheckRepositoryJob.perform_later(repository.checks.last)
    repository_api.create_hook(github_id, api_checks_url)
  end
end
