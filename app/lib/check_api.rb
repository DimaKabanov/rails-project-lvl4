# frozen_string_literal: true

def start_process(command)
  Open3.popen3(command) { |_stdin, stdout| stdout.read }
end

class CheckApi
  def self.create_repo_dir(repo_path)
    if Dir.exist?(repo_path)
      FileUtils.remove_dir(repo_path, true)
    end

    Dir.mkdir(repo_path)
  end

  def self.remove_repo_dir(repo_path)
    FileUtils.remove_dir(repo_path, true)
  end

  def self.clone_repo(clone_command)
    start_process(clone_command)
  end

  def self.remove_config(remove_config_command)
    start_process(remove_config_command)
  end

  def self.check_repo(check_command)
    start_process(check_command)
  end
end
