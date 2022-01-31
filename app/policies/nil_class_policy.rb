# frozen_string_literal: true

class NilClassPolicy < ApplicationPolicy
  def index?
    false
  end
end
