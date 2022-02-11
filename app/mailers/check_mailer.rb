# frozen_string_literal: true

class CheckMailer < ApplicationMailer
  def check_success_email
    @check = params[:check]
    @user = @check.repository.user

    mail(
      to: @user.email,
      subject: t('.success_subject')
    )
  end

  def check_error_email
    @check = params[:check]
    @user = @check.repository.user

    mail(
      to: @user.email,
      subject: t('.error_subject')
    )
  end
end
