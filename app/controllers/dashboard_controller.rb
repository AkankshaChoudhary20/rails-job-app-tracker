class DashboardController < ApplicationController
  def index
    @counts_by_status = current_user.application_counts_by_status
    @total_count = current_user.applications.count
    @recent_applications = current_user.applications.recent.limit(5)
  end
end
