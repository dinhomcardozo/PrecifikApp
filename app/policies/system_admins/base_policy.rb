module SystemAdmins
  class BasePolicy < ApplicationPolicy
    def create?
      user.super_admin?
    end

    def update?
      user.super_admin?
    end

    def destroy?
      user.super_admin?
    end

    def index?
      user.present?
    end

    def show?
      user.present?
    end
  end
end