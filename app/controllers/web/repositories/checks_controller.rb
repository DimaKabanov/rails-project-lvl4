# frozen_string_literal: true

class Web::Repositories::ChecksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: %i[checks]

  def create
    @repository = Repository.find(params[:repository_id])
    @check = @repository.checks.build

    if @check.save
      RepositoryCheckJob.perform_later @repository.id, @check.id
      redirect_to @repository, notice: t('.success')
    else
      redirect_to @repository
    end
  end

  def show
    @check = RepositoryCheck.find(params[:id])
  end

  def checks
    @repository = Repository.find_by(repo_name: params[:repository][:full_name])
    @check = @repository.checks.build

    if @check.save
      RepositoryCheckJob.perform_later @repository.id, @check.id
    end
    else
  end
end
