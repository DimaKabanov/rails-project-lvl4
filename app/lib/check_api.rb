# frozen_string_literal: true

class CheckApi
  def initialize(repository)
    @repo_path = "tmp/#{repository.name}"
    @clone_url = repository.clone_url
    @language = repository.language.to_sym
  end

  def create_repo_dir
    if Dir.exist?(@repo_path)
      FileUtils.remove_dir(@repo_path, true)
    end

    Dir.mkdir(@repo_path)
  end

  def remove_repo_dir
    FileUtils.remove_dir(@repo_path, true)
  end

  def clone_repo
    clone_command = "git clone #{@clone_url} #{@repo_path}"
    run_process(clone_command)
  end

  def check_repo
    checks = {
      javascript: -> { check_javascript },
      ruby: -> { check_ruby }
    }

    checks[@language].call
  end

  private

  def run_process(command)
    Open3.popen3(command) { |_stdin, stdout| stdout.read }
  end

  def check_javascript
    check_command = "yarn run eslint #{@repo_path} --config #{Rails.root.join('.eslintrc.yml')} --no-eslintrc --format json"
    check_results = run_process(check_command)

    all_results = JSON.parse(check_results[/\[.*]/])
    failed_results = all_results.filter { |result| result['errorCount'].positive? }

    results = failed_results.map do |result|
      {
        file_path: result['filePath'],
        messages: result['messages'].map do |message|
          {
            message: message['message'],
            rule: message['ruleId'],
            line_column: "#{message['line']}:#{message['column']}"
          }
        end
      }
    end

    error_count = all_results.sum { |result| result['errorCount'] }

    { results: JSON.generate(results), error_count: error_count }
  end

  def check_ruby
    check_command = "bundle exec rubocop #{@repo_path} --format json"
    check_results = run_process(check_command)

    all_results = JSON.parse(check_results)
    failed_results = all_results['files'].filter { |file| file['offenses'].any? }

    results = failed_results.map do |file|
      {
        file_path: file['path'],
        messages: file['offenses'].map do |offense|
          {
            message: offense['message'],
            rule: offense['cop_name'],
            line_column: "#{offense['location']['line']}:#{offense['location']['column']}"
          }
        end
      }
    end

    error_count = all_results['summary']['offense_count']

    { results: JSON.generate(results), error_count: error_count }
  end
end
