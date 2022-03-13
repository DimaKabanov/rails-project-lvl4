# frozen_string_literal: true

require 'test_helper'

class Api::ChecksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in_as_user @user
    @attrs = {
      full_name: 'DimaKabanov/Algorithms'
    }
  end

  test 'should create new check' do
    post api_checks_path params: {
      repository: @attrs
    }

    repository = Repository.find_by! full_name: @attrs[:full_name]
    check = repository.checks.last

    assert { check.finished? }
    assert { check.passed? }
  end
end
