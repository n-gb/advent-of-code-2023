require_relative 'advent_data'

data = AdventData.new(day: 5, session: ARGV[0]).get

split_data = [[]]

data.each do |line|
  if line == ''
    split_data << []
    next
  end

  split_data.last << line.scan(/\d+/).map(&:to_i) if line.scan(/\d+/).any?
end

seeds = split_data.first.flatten
transformation_maps = split_data.drop(1)

source_data = seeds

transformation_maps.each do |map|
  results = []
  mapped_data = []

  source_data.each do |number|
    map.each do |values|
      destination_range_start, source_range_start, range_length = values
      destination_range_end = destination_range_start + range_length - 1
      source_range_end = source_range_start + range_length - 1

      if source_range_start <= number && source_range_end >= number
        item_index = source_range_end - number
        results << (destination_range_end - item_index)
        mapped_data << number
      end
    end
  end

  results << (source_data - mapped_data) if source_data.length > mapped_data.length

  source_data = results.flatten
end

puts source_data.min
