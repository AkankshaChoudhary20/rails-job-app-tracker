class Application < ApplicationRecord
  belongs_to :user

  # Order matters: it defines the integer values persisted in the
  # `status` column, so once this ships, only append to the end.
  enum status: {
    applied: 0,
    screening: 1,
    interview: 2,
    offer: 3,
    rejected: 4
  }

  validates :company, presence: true
  validates :role, presence: true
  validates :applied_date, presence: true
  validates :status, presence: true

  scope :recent, -> { order(applied_date: :desc, created_at: :desc) }
  scope :active, -> { where.not(status: :rejected) }

  # Statuses that still represent an open, in-progress application.
  # Kept as a single source of truth so the dashboard "active" count
  # and any future filtering agree with each other.
  OPEN_STATUSES = %w[applied screening interview offer].freeze

  def open?
    OPEN_STATUSES.include?(status)
  end
end
