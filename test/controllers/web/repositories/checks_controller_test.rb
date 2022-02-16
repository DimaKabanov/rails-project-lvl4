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
    debugger
    assert_response :success
  end
end
