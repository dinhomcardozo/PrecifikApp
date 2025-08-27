# app/policies/system_admins/user_admin_policy.rb
module SystemAdmins
  class UserAdminPolicy < BasePolicy
    def create?
      user.admin?
    end

    def update?
      user.admin?
    end

    def destroy?
      user.admin?
    end

    def index?
      user.present?
    end

    def show?
      user.present?
    end
  end
end