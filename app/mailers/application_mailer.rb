# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'github-quality@hexlet.com'
  layout 'mailer'
end
