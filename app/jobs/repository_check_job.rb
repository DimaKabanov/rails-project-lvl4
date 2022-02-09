# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  queue_as :default

  def perform(repository_id, check_id)
    repository = Repository.find(repository_id)
    check = RepositoryCheck.find(check_id)

    repo_path = 'tmp/repo'

    if Dir.exist?(repo_path)
      FileUtils.remove_dir(repo_path, true)
    end

    Dir.mkdir(repo_path)

    clone_command = "git clone #{repository.clone_url} #{repo_path}"
    start_process(clone_command)

    check.check!

    actions = get_check_actions(repository.language.to_sym)

    remove_config_command = actions[:get_remove_config_command].call(repo_path)
    start_process(remove_config_command)

    check_command = actions[:get_check_command].call(repo_path)
    check_results, _exit_status = start_process(check_command)

    results = JSON.parse(check_results)

    error_count = actions[:get_error_count].call(results)
    parsed_results = actions[:parse_check_results].call(results)

    check.update(
      passed: error_count.zero?,
      error_count: error_count,
      result: JSON.generate(parsed_results)
    )

    check.finish!

    FileUtils.remove_dir(repo_path, true)
  end

  private

  def start_process(command)
    Open3.popen3(command) { |_stdin, stdout, _stderr, wait_thr| [stdout.read, wait_thr.value] }
  end

  def get_check_actions(language)
    actions = {
      javascript: {
        get_remove_config_command: ->(path) { "find #{path} -name '.eslintrc*' -delete" },
        get_check_command: ->(path) { "npx eslint #{path} -f json" },
        parse_check_results: ->(results) { parse_eslint_results(results) },
        get_error_count: ->(results) { results.sum { |result| result['errorCount'] } }
      },
      ruby: {
        get_remove_config_command: ->(_path) { ':' },
        get_check_command: ->(path) { "bundle exec rubocop #{path} --format json" },
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
