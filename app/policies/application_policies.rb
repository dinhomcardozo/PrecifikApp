  attr_reader :user, :record

  def initialize(user, record)
    @user    = user
    @record  = record
  end

  def admin?
    user.is_a?(SystemAdmins::UserAdmin) && user.admin?
  end

  def allowed?(feature_slug)
    return true if admin?
    # para client users:
    plan = user.client.plan
    plan.features.exists?(slug: feature_slug)
  end