# frozen_string_literal: true

def get_fixture_path(name)
  Rails.root.join("test/fixtures/files/#{name}")
end

class CheckApiStub
  def initialize(_repository); end

  def create_repo_dir; end

  def remove_repo_dir; end

  def clone_repo; end

  def check_repo
    results_path = get_fixture_path('results.json')
    { error_count: 0, results: File.read(results_path) }
  end
end
