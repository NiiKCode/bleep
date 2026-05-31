module ApplicationHelper
  def formatted_session_date(date)
    date.strftime("%a %-d %b")
  end

  def city_code(city)
    {
      "London" => "LDN",
      "Manchester" => "MAN",
      "Birmingham" => "BHX",
      "Liverpool" => "LPL",
      "Leeds" => "LDS",
      "Bristol" => "BRS"
    }[city] || city.first(3).upcase
  end
end
