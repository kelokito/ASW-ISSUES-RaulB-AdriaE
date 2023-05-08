json.extract! issue, :id, :subject, :description, :created_at, :updated_at, :due_date, :blocked, :blocked_reason, :watchers, :typeIssue, :severityIssue, :priorityIssue, :statusIssue, :user_id, :createdBy
json.url issue_url(issue, format: :json)
