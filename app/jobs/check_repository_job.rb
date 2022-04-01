# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :default

  def perform(check)
    repository = check.repository

    check_api = ApplicationContainer[:check_api].new(repository)
    repository_api = ApplicationContainer[:repository_api].new(repository.user.token)

    check.check!

    begin
      check_api.create_repo_dir
      check_api.clone_repo
      check_result = check_api.check_repo

      last_commit = repository_api.repository_commits(repository.github_id.to_i).first

      check.update(
        passed: check_result[:error_count].zero?,
        error_count: check_result[:error_count],
        language: repository.language,
        result: check_result[:results],
        reference_url: last_commit[:html_url],
        reference_sha: last_commit[:sha][0, 8]
      )

      check.finish!
      CheckMailer.with(check: check).check_success_email.deliver_now
    rescue StandardError
      check.reject!
      CheckMailer.with(check: check).check_error_email.deliver_now
    ensure
      check_api.remove_repo_dir
    end
  end
end
