require_relative 'advent_data'

data = AdventData.new(day: 3, session: ARGV[0]).get

data_numbers_indices = []
data_gear_indices = []

data.each do |engine_schematic_string|
  numbers_indices = []
  numbers = engine_schematic_string.scan(/\d+/) do |number|
    start_index = $~.offset(0)[0]
    numbers_indices << (start_index...start_index + number.length)
  end
  data_numbers_indices << numbers_indices

  data_gear_indices << engine_schematic_string.chars.each_index.select { |i| engine_schematic_string[i] == '*' }
end

gear_ratios = []

data_gear_indices.each_with_index do |gear_indices, line_number|
  next if gear_indices.none?

  gear_indices.each do |gear_index|
    relevant_lines = [line_number - 1, line_number, line_number + 1]
    relevant_lines.delete(-1)
    relevant_lines.delete(data.length)

    number_indices_hash = {}
    relevant_lines.each { |line| number_indices_hash[line] = data_numbers_indices[line] }
    adjacent_numbers = number_indices_hash.map do |line, indices|
      adjacent_numbers_indices =
        indices.select { |number_indices| ((number_indices.first - 1)..number_indices.last) === gear_index }
      adjacent_numbers_indices.map { |number_indices| data[line][number_indices].to_i }
    end.flatten
    
    gear_ratios << adjacent_numbers.reduce(:*) if adjacent_numbers.count > 1
  end
end

puts gear_ratios.sum
