require_relative 'advent_data'

data = AdventData.new(day: 15, session: ARGV[0]).get.first

values = data.split(',').map do |string|
  current_value = 0

  string.each_byte do |char|
    current_value += char
    current_value *= 17
    current_value %= 256
  end

  current_value
end

puts values.inject(&:+)
