require_relative 'advent_data'

data = AdventData.new(day: 1, session: ARGV[0]).get

calibration_values = data.map do |string|
  numbers = string.scan(/\d/)
  (numbers.first + numbers.last).to_i
end

puts calibration_values.sum
