module ApplicationHelper
  def rate_options
    (1..5).to_a.map do |number|
      [number.to_s + " #{number > 1 ? 'stars' : 'star'}", number]
    end
  end
end
