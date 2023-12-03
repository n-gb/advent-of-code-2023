require_relative 'advent_data'

data = AdventData.new(day: 3, session: ARGV[0]).get

data_numbers_indices = []
data_symbols_indices = []

data.each do |engine_schematic_string|
  numbers_indices = []
  numbers = engine_schematic_string.scan(/\d+/) do |number|
    start_index = $~.offset(0)[0]
    numbers_indices << (start_index...start_index + number.length)
  end
  data_numbers_indices << numbers_indices

  symbols = engine_schematic_string.scan(/\D/)
  symbols.delete('.')
  symbols_indices = []
  symbols = symbols.uniq
  symbols.each do |symbol|
    symbols_indices << engine_schematic_string.chars.each_index.select { |i| engine_schematic_string[i] == symbol }
  end
  data_symbols_indices << symbols_indices.flatten
end

part_numbers = []

data_numbers_indices.each_with_index do |numbers_indices, line_number|
  numbers_indices.each do |number_indices|
    relevant_lines = [line_number - 1, line_number, line_number + 1]
    relevant_lines.delete(-1)
    relevant_lines.delete(data.length)
    symbols_indices = data_symbols_indices[(relevant_lines.first..relevant_lines.last)].flatten
    adjacent_symbols =
      symbols_indices.select { |symbol_index| ((number_indices.first - 1)..number_indices.last) === symbol_index }
    part_numbers << data[line_number][number_indices].to_i if adjacent_symbols.any?
  end
end

puts part_numbers.sum
