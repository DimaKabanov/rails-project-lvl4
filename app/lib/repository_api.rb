# frozen_string_literal: true

class RepositoryApi
  def initialize(token)
    @client = Octokit::Client.new(access_token: token, per_page: 100)
  end

  def repositories
    @client.repos
  end

  def repository(github_id)
    @client.repo(github_id)
  end

  def repository_commits(github_id)
    @client.commits(github_id)
  end

  def create_hook(github_id, url)
    @client.create_hook(
      github_id,
      'web',
      {
        url: url,
        content_type: 'json'
      },
      {
        events: ['push'],
        active: true
      }
    )
  end
end
