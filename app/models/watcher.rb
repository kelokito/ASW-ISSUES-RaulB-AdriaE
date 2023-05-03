class Watcher < ApplicationRecord
  validates_uniqueness_of :issue_id, scope: :user_id
end
