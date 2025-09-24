class CreateJoinTableMessagesPlans < ActiveRecord::Migration[8.0]
  def change
    create_join_table :messages, :plans do |t|
      # t.index [:message_id, :plan_id]
      # t.index [:plan_id, :message_id]
    end
  end
end
