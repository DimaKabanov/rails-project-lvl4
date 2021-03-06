# frozen_string_literal: true

class ApplicationContainer
  extend Dry::Container::Mixin

  if Rails.env.test?
    register :repository_api, -> { RepositoryApiStub }
    register :check_api, -> { CheckApiStub }
  else
    register :repository_api, -> { RepositoryApi }
    register :check_api, -> { CheckApi }
  end
end
