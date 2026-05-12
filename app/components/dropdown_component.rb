class DropdownComponent < ViewComponent::Base
  def initialize(name:, options:, selected:, label: nil, value_method: nil, label_method: nil)
    @name = name
    @label = label
    @options = options.compact
    @selected = selected
    @value_method = value_method
    @label_method = label_method
  end

  # -------------------------
  # LABEL
  # -------------------------
  def option_label(option)
    return "" if option.nil?

    if option.is_a?(Array)
      option.first

    elsif @label_method && option.respond_to?(@label_method)
      option.public_send(@label_method)

    else
      option.to_s
    end
  end

  # -------------------------
  # VALUE
  # -------------------------
  def option_value(option)
    return nil if option.nil?

    if option.is_a?(Array)
      option.last

    elsif @value_method && option.respond_to?(@value_method)
      option.public_send(@value_method)

    else
      option
    end
  end

  # -------------------------
  # SELECTED LABEL (🔥 critical fix)
  # -------------------------
  def selected_label
    return "" if @selected.nil?

    matching_option =
      @options.find do |option|
        option_value(option) == option_value(@selected)
      end

    return option_label(matching_option) if matching_option.present?

    if @label_method && @selected.respond_to?(@label_method)
      @selected.public_send(@label_method)
    else
      @selected.to_s
    end
  end
end
