class SectionComponent < ViewComponent::Base
  def initialize(title:, open: true)
    @title = title
    @open = open
  end
end
