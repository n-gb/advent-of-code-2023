require_relative 'advent_data'

data = AdventData.new(day: 4, session: ARGV[0]).get

total_points = data.map do |card|
  numbers = card.split(':').last
  winning_numbers, present_numbers = numbers.split('|')
  winning_numbers = winning_numbers.scan(/\d+/).map(&:to_i)
  present_numbers = present_numbers.scan(/\d+/).map(&:to_i)
  present_winning_numbers = winning_numbers & present_numbers
  number_of_present_winning_numbers = present_winning_numbers.count

  points = number_of_present_winning_numbers > 0 ? 1 : 0

  (number_of_present_winning_numbers - 1).times do
    points = points * 2
  end
  
  points
end

puts total_points.sum
