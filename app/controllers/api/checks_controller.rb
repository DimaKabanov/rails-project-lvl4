# frozen_string_literal: true

class Api::ChecksController < Api::ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[checks]

  def checks
    @repository = Repository.find_by(repo_name: params[:repository][:full_name])
    @check = @repository.checks.build

    RepositoryCheckJob.perform_later(@repository.id, @check.id) if @check.save
  end
end
