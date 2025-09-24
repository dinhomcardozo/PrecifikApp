module SystemAdmins
  class Plan < ApplicationRecord
    self.table_name = 'plans'

    has_and_belongs_to_many :messages,
                        class_name: "Message",
                        join_table: "messages_plans"
  end
end
