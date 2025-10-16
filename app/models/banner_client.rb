class BannerClient < ApplicationRecord
  belongs_to :banner, class_name: "SystemAdmins::Banner"
  belongs_to :client, class_name: "SystemAdmins::Client"
end