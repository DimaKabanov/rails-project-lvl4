# frozen_string_literal: true

require 'test_helper'

class UpdateInfoRepositoryJobTest < ActiveJob::TestCase
  test 'update created check' do
    repo = repositories :created

    UpdateInfoRepositoryJob.perform_now repo
    repo.reload

    full_name = 'DimaKabanov/Algorithms'
    language = 'javascript'

    assert { full_name == repo.full_name }
    assert { language == repo.language }
  end
end
