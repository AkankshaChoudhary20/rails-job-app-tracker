class User < ApplicationRecord
  has_secure_password

  has_many :applications, dependent: :destroy

  normalizes :email, with: ->(email) { email.strip.downcase }

  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, allow_nil: true

  # Counts of this user's applications grouped by status, e.g.
  # { "applied" => 3, "interview" => 1 }. Used by the dashboard.
  def application_counts_by_status
    Application.statuses.keys.index_with { |status| 0 }
      .merge(applications.group(:status).count)
  end
end
