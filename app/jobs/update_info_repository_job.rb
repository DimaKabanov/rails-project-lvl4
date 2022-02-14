# frozen_string_literal: true

class UpdateInfoRepositoryJob < ApplicationJob
  include Rails.application.routes.url_helpers

  queue_as :default

  def perform(repository)
    github_id = repository.github_id
    pp repository
    client = Octokit::Client.new(access_token: repository.user.token, per_page: 200)
    found_repo = client.repo(github_id)

    repository.update(
      github_id: found_repo[:id],
      full_name: found_repo[:full_name],
      name: found_repo[:name],
      clone_url: found_repo[:clone_url],
      language: found_repo[:language].downcase
    )

    CheckRepositoryJob.perform_later(repository)

    client.create_hook(
      repository.github_id,
      'web',
      {
        url: api_checks_url,
        content_type: 'json'
      },
      {
        events: ['push'],
        active: true
      }
    )
  end
end
