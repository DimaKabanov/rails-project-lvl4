# frozen_string_literal: true

def get_fixture_path(name)
  Rails.root.join("test/fixtures/files/#{name}")
end

class CheckApiStub
  def self.create_repo_dir(_repo_path); end

  def self.remove_repo_dir(_repo_path); end

  def self.clone_repo(_clone_command); end

  def self.remove_config(_remove_config_command); end

  def self.check_repo(_check_command)
    results_path = get_fixture_path('results.json')
    File.read(results_path)
  end
end
