module Clients
  class BasePolicy < ApplicationPolicy
    def index?
      cliente_logado?
    end

    def show?
      cliente_logado?
    end

    def new?
      cliente_logado?
    end

    def create?
      cliente_logado?
    end

    def edit?
      cliente_logado?
    end

    def update?
      cliente_logado?
    end

    private

    def cliente_logado?
      user.is_a?(SystemAdmins::UserClient)
    end
  end
end