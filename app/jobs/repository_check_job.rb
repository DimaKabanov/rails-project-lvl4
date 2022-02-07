# frozen_string_literal: true

class RepositoryCheckJob < ApplicationJob
  queue_as :default

  def perform(repository_id, check_id)
    repository = Repository.find(repository_id)
    check = RepositoryCheck.find(check_id)

    repo_path = 'tmp/repo'
    
    if Dir.exist? repo_path
      FileUtils.remove_dir repo_path, true
    end

    Dir.mkdir(repo_path)

    clone_command = "git clone #{repository.clone_url} #{repo_path}"
    start_process(clone_command)

    remove_config_command = "find #{repo_path} -name '.eslintrc*' -delete"
    start_process(remove_config_command)

    check.check!

    check_command = "npx eslint #{repo_path} -f json"
    check_results, _exit_status = start_process(check_command)

    total_error_count = JSON.parse(check_results).sum { |result| result['errorCount'] }

    check.update(
      passed: total_error_count.zero?,
      result: check_results
    )

    check.finish!

    FileUtils.remove_dir repo_path, true
  end

  private

  def start_process(command)
    Open3.popen3(command) { |_stdin, stdout, _stderr, wait_thr| [stdout.read, wait_thr.value] }
  end
end
