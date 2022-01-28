# frozen_string_literal: true

class Web::RepositoriesController < ApplicationController
  def index
    @repositories = current_user.repositories
  end

  def new
    client = Octokit::Client.new access_token: ENV['GITHUB_PERSONAL_ACCESS_TOKEN'], per_page: 200
    client.repos
    @repository = current_user.repositories.build
  end

  def create
    @repository = current_user.repositories.build(bulletin_params)

    if @repository.save
      redirect_to repositories_path, notice: t('.success')
    else
      render :new
    end
  end

  private

  def repository_params
    params.require(:repository).permit(:link)
  end
end
