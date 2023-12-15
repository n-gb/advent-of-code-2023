require_relative 'advent_data'

data = AdventData.new(day: 14, session: ARGV[0]).get

tilt_data = data

tilt_data.each_with_index do |line, line_index|
  line.chars.each_with_index do |char, char_index|
    if char == 'O'
      moving_index = line_index

      while moving_index != 0 do
        moving_index -= 1

        break if tilt_data[moving_index][char_index] == '#' || tilt_data[moving_index][char_index] == 'O'

        tilt_data[moving_index][char_index] = 'O'
        tilt_data[moving_index + 1][char_index] = '.'
      end
    end
  end
end

weight = 0

tilt_data.each_with_index do |line, line_index|
  num_of_stones = line.chars.select { |char| char == 'O' }.length
  weight += num_of_stones * (tilt_data.length - line_index)
end

puts weight
