# frozen_string_literal: true

require 'test_helper'

class Web::RepositoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in_as_user @user
    @attrs = {
      github_id: '4'
    }
  end

  test 'should get index' do
    get repositories_path
    assert_response :success
  end

  test 'should get show' do
    repository = repositories :updated
    get repository_path repository
    assert_response :redirect
  end

  test 'should get new' do
    get new_repository_path
    assert_response :success
  end

  test 'should create new repo' do
    post repositories_url, params: {
      repository: @attrs
    }

    repository = Repository.find_by! github_id: @attrs[:github_id]

    assert_redirected_to repositories_path
    assert { repository }

    full_name = 'DimaKabanov/Algorithms'
    language = 'javascript'

    assert { full_name == repository.full_name }
    assert { language == repository.language }
  end
end
