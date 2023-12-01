require_relative 'advent_data'

data = AdventData.new(day: 1, session: ARGV[0]).get
number_vocabulary = {
  'one' => 'o1e',
  'two' => 't2o',
  'three' => 't3e',
  'four' => 'f4r',
  'five' => 'f5e',
  'six' => 's6x',
  'seven' => 's7n',
  'eight' => 'e8t',
  'nine' => 'n9e'
}

join_data = data.join(' ')

number_vocabulary.each do |name_string, number_with_first_and_last_name_letter|
  join_data.gsub! name_string, number_with_first_and_last_name_letter
end

disjoin_data = join_data.split(' ')

calibration_values = disjoin_data.map do |string|
  numbers = string.scan(/\d/)
  (numbers.first + numbers.last).to_i
end

puts calibration_values.sum
