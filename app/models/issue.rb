class Issue < ApplicationRecord
  validates :subject, length: { minimum: 4, too_short: "value is required" }
  serialize :watchers
  after_initialize do |issue|
    issue.watchers= [] if issue.watchers == nil
  end

  has_many :comments, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_many :attachments, dependent: :destroy

end
