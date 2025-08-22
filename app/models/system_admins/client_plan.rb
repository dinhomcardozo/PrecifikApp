module SystemAdmins
  class ClientPlan < ApplicationRecord
    belongs_to :client
    belongs_to :plan
  end
end
