require_relative 'advent_data'

data = AdventData.new(day: 5, session: ARGV[0]).get

def delete_processed_ranges(unprocessed_ranges, processed_range)
  new_unprocessed_ranges = []

  unprocessed_ranges.each do |unprocessed_range|
    case
    when processed_range.first <= unprocessed_range.first && processed_range.last >= unprocessed_range.last
      # We remove the whole unprocessed range, because it is processed now
    when processed_range.first >= unprocessed_range.first && processed_range.last <= unprocessed_range.last
      # The range is contained within the bigger one, we split it
      new_unprocessed_ranges << (unprocessed_range.first..processed_range.first)
      new_unprocessed_ranges << (processed_range.last..unprocessed_range.last)
    when processed_range.first >= unprocessed_range.first && processed_range.last >= unprocessed_range.last && processed_range.first <= unprocessed_range.last
      # We remove the right side of unprocessed range and keep the left side
      new_unprocessed_ranges << (unprocessed_range.first..processed_range.first)
    when processed_range.first <= unprocessed_range.first && processed_range.last <= unprocessed_range.last && processed_range.last >= unprocessed_range.first
      # We remove the left side of unprocessed range and keep the right side
      new_unprocessed_ranges << (processed_range.last..unprocessed_range.last)
    else
      # We keep everything, there are no matches
      new_unprocessed_ranges << unprocessed_range
    end
  end

  new_unprocessed_ranges
end

split_data = [[]]

data.each do |line|
  if line == ''
    split_data << []
    next
  end

  split_data.last << line.scan(/\d+/).map(&:to_i) if line.scan(/\d+/).any?
end

seeds = split_data.first.flatten.each_slice(2).to_a
transformation_maps = split_data.drop(1)

source_data = []

seed_ranges = seeds.map do |start_length|
  start, length = start_length
  (start..(start + length - 1))
end

current_ranges = seed_ranges

transformation_maps.each_with_index do |map, index|
  results = []
  processed_ranges = []
  unprocessed_ranges = []

  current_ranges.each do |current_range|
    current_start = current_range.first
    current_end = current_range.last

    map.each do |values|
      destination_range_start, source_range_start, range_length = values

      distance = source_range_start - destination_range_start
      source_range_end = source_range_start + range_length

      case
      when source_range_start <= current_start && source_range_end >= current_end
        processed_range = current_range
        resulting_destination_start = current_start - distance
        resulting_destination_end = current_end - distance
        resulting_destination_range = (resulting_destination_start..resulting_destination_end)

        results << resulting_destination_range
        processed_ranges << processed_range
        unprocessed_ranges = delete_processed_ranges(unprocessed_ranges, processed_range)
      when source_range_start >= current_start && source_range_end >= current_end && source_range_start <= current_end
        processed_range = (source_range_start..current_end)
        resulting_destination_start = source_range_start - distance
        resulting_destination_end = current_end - distance
        resulting_destination_range = (resulting_destination_start..resulting_destination_end)

        results << resulting_destination_range
        processed_ranges << processed_range

        unprocessed_range = (current_start..source_range_start)
        unprocessed_ranges << unprocessed_range unless processed_ranges.include?(unprocessed_range)
        unprocessed_ranges = delete_processed_ranges(unprocessed_ranges, processed_range)
      when source_range_start <= current_start && source_range_end <= current_end && source_range_end >= current_start
        processed_range = (current_start..source_range_end)
        resulting_destination_start = current_start - distance
        resulting_destination_end = source_range_end - distance
        resulting_destination_range = (resulting_destination_start..resulting_destination_end)

        results << resulting_destination_range
        processed_ranges << processed_range

        unprocessed_range = (source_range_end..current_end)
        unprocessed_ranges << unprocessed_range unless processed_ranges.include?(unprocessed_range)
        unprocessed_ranges = delete_processed_ranges(unprocessed_ranges, processed_range)
      when source_range_start >= current_start && source_range_end <= current_end
        processed_range = (source_range_start..source_range_end)
        resulting_destination_start = source_range_start - distance
        resulting_destination_end = source_range_end - distance
        resulting_destination_range = (resulting_destination_start..resulting_destination_end)

        results << resulting_destination_range
        processed_ranges << processed_range

        first_unprocessed_range = (current_start..source_range_start)
        unprocessed_ranges << first_unprocessed_range unless processed_ranges.include?(first_unprocessed_range)
        second_unprocessed_range = (source_range_end..current_end)
        unprocessed_ranges << second_unprocessed_range unless processed_ranges.include?(second_unprocessed_range)
        unprocessed_ranges = delete_processed_ranges(unprocessed_ranges, processed_range)
      else
        unprocessed_ranges << current_range unless processed_ranges.include?(current_range)
      end
    end
  end

  processed_ranges.each do |processed_range|
    unprocessed_ranges = delete_processed_ranges(unprocessed_ranges, processed_range)
  end

  results << unprocessed_ranges if unprocessed_ranges.any?

  current_ranges = results.flatten.uniq
end

min_values = current_ranges.map { |range| range.first }

puts min_values.min
