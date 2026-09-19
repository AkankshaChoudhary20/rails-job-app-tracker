module ApplicationsHelper
  STATUS_LABELS = {
    "applied" => "Applied",
    "screening" => "Screening",
    "interview" => "Interview",
    "offer" => "Offer",
    "rejected" => "Rejected"
  }.freeze

  def status_label(status)
    STATUS_LABELS.fetch(status.to_s, status.to_s.titleize)
  end

  def status_badge_class(status)
    "status-badge status-#{status}"
  end
end
