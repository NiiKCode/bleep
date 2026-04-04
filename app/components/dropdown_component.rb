class DropdownComponent < ViewComponent::Base
  def initialize(name:, options:, selected:, label: nil, value_method: nil, label_method: nil)
    @name = name
    @label = label
    @options = options
    @selected = selected
    @value_method = value_method
    @label_method = label_method
  end

  def option_label(option)
    if option.is_a?(Array)
      option.first
    elsif @label_method
      option.public_send(@label_method)
    else
      option.to_s
    end
  end

  def option_value(option)
    if option.is_a?(Array)
      option.last
    elsif @value_method
      option.public_send(@value_method)
    else
      option
    end
  end

  # 🔥 ADD THIS METHOD HERE
  def selected_label
    pair = @options.find do |opt|
      opt.is_a?(Array) && opt.last == @selected
    end

    return pair.first if pair

    option_label(@selected)
  end
end
