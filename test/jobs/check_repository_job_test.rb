# frozen_string_literal: true

require 'test_helper'

class CheckRepositoryJobTest < ActiveJob::TestCase
  test 'update created check' do
    check = repository_checks :created

    CheckRepositoryJob.perform_now check
    check.reload

    assert { check.finished? }
    assert { check.passed? }
  end
end
