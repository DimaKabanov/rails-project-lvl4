# frozen_string_literal: true

class CheckRepositoryJob < ApplicationJob
  queue_as :default

  before_perform do
    @repo_path = 'tmp/repo'
    @check_api = ApplicationContainer[:check_api]

    @check_api.create_repo_dir(@repo_path)
  end

  after_perform do
    @check_api.remove_repo_dir(@repo_path)
  end

  def perform(check)
    repository_api = ApplicationContainer[:repository_api]
    repository = check.repository

    check.check!

    begin
      clone_command = "git clone #{repository.clone_url} #{@repo_path}"
      @check_api.clone_repo(clone_command)

      actions = get_check_actions(repository.language.to_sym)

      remove_config_command = actions[:remove_config_command]
      @check_api.remove_config(remove_config_command)

      check_command = actions[:check_command]
      check_results = @check_api.check_repo(check_command)

      results = JSON.parse(check_results)

      error_count = actions[:get_error_count].call(results)
      parsed_results = actions[:parse_check_results].call(results)

      client = repository_api.client(repository.user.token)
      last_commit = repository_api.get_repository_commits(client, repository.github_id.to_i).first

      check.update(
        passed: error_count.zero?,
        error_count: error_count,
        language: repository.language,
        result: JSON.generate(parsed_results),
        reference_url: last_commit[:html_url],
        reference_sha: last_commit[:sha][0, 8]
      )

      check.finish!
      CheckMailer.with(check: check).check_success_email.deliver_now
    rescue StandardError => e
      pp e
      check.reject!
      CheckMailer.with(check: check).check_error_email.deliver_now
    end
  end

  private

  def get_check_actions(language)
    actions = {
      javascript: {
        remove_config_command: "find #{@repo_path} -name '.eslintrc*' -delete",
        check_command: "npx eslint #{@repo_path} -f json",
        parse_check_results: ->(results) { parse_eslint_results(results) },
        get_error_count: ->(results) { results.sum { |result| result['errorCount'] } }
      },
      ruby: {
        remove_config_command: ':',
        check_command: "bundle exec rubocop #{@repo_path} --format json",
        parse_check_results: ->(results) { parce_rubocop_result(results) },
        get_error_count: ->(results) { results['summary']['offense_count'] }
      }
    }

    actions[language]
  end

  def parse_eslint_message(message)
    {
      message: message['message'],
      rule: message['ruleId'],
      line_column: "#{message['line']}:#{message['column']}"
    }
  end

  def parse_eslint_results(results)
    results
      .filter { |result| result['errorCount'].positive? }
      .map do |result|
        {
          file_path: result['filePath'],
          messages: result['messages'].map { |message| parse_eslint_message(message) }
        }
      end
  end

  def parse_rubocop_offense(offense)
    {
      message: offense['message'],
      rule: offense['cop_name'],
      line_column: "#{offense['location']['line']}:#{offense['location']['column']}"
    }
  end

  def parce_rubocop_result(results)
    results['files']
      .filter { |file| file['offenses'].any? }
      .map do |file|
        {
          file_path: file['path'],
          messages: file['offenses'].map { |offense| parse_rubocop_offense(offense) }
        }
      end
  end
end
