module ApplicationHelper
  def formatted_session_date(date)
    date.strftime("%a %-d %b")
  end
end
