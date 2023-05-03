module IssuesHelper

  def get_issue_type_color(issue_type)
    case issue_type
    when 0 #"Bug"
      "#E44057"
    when 1 #"Question"
      "#5178D3"
    when 2 #"Enhancement"
      "#40E4CE"
    when 3 #"To do"
      "#A9AABC"
    else
      "#FFFFFF" # Error
    end
  end

  def get_issue_severity_color(issue_severity)
    case issue_severity
    when 0 #"Wishlist"
      "#70728F"
    when 1 #"Minor"
      "#40A8E4"
    when 2 #"Normal"
      "#40E47C"
    when 3 #"Important"
      "#E4A240"
    when 4 #"Critical"
      "#D35450"
    else
      "#FFFFFF" # Error
    end
  end

  def get_issue_priority_color(priority)
    case priority
    when 0 #"Low"
      "#A8E440"
    when 1 #"Normal"
      "#E4CE40"
    when 2 #"High"
      "#E47C40"
    else
      "#FFFFFF" # Error
    end
  end

end
