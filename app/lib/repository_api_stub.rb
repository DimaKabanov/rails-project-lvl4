# frozen_string_literal: true

def get_fixture_path(name)
  Rails.root.join("test/fixtures/files/#{name}")
end

class RepositoryApiStub
  def initialize(_token); end

  def repositories
    repos_path = get_fixture_path('repositories.json')
    JSON.parse(File.read(repos_path)).map(&:symbolize_keys)
  end

  def repository(_github_id)
    repo_path = get_fixture_path('repository.json')
    JSON.parse(File.read(repo_path)).symbolize_keys
  end

  def repository_commits(_github_id)
    commits_path = get_fixture_path('commits.json')
    JSON.parse(File.read(commits_path)).map(&:symbolize_keys)
  end

  def create_hook(_github_id, _url); end
end
