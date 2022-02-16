# frozen_string_literal: true

require 'test_helper'

class Web::Repositories::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in_as_user @user
  end

  test 'should get show' do
    repository = repositories :updated
    check = repository_checks :updated

    get repository_check_path repository, check
    assert_response :success
  end

  test 'should create new check' do
    repository = repositories :without_checks
    post repository_checks_path repository

    check = repository.checks.last

    assert { check.created? }
    assert { !check.passed? }
  end
end
