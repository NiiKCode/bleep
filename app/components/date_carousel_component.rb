class DateCarouselComponent < ViewComponent::Base
  def initialize(dates:, selected_date:)
    @dates = dates
    @selected_date = selected_date
  end
end
