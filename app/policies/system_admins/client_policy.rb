# app/policies/system_admins/client_policy.rb
module SystemAdmins
  class ClientPolicy < BasePolicy

    def create?
      user.present?
    end
  end
end
