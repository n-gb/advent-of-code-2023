require_relative 'advent_data'

data = AdventData.new(day: 11, session: ARGV[0]).get

mapped_data = data.map { |line| line.chars }

expandable_rows = []
index = 0

mapped_data.each_with_index do |row, index|
  expandable_rows << index if row.uniq == ['.']
end

mapped_data = mapped_data.transpose
expandable_columns = []
index = 0

mapped_data.each_with_index do |column, index|
  expandable_columns << index if column.uniq == ['.']
end

mapped_data = mapped_data.transpose
galaxy_coordinates = []

mapped_data.each_with_index do |row, i|
  row.each_with_index do |item, j|
    galaxy_coordinates << [i, j] if item == '#'
  end
end

galaxy_pairs = galaxy_coordinates.combination(2).to_a

shortest_paths = galaxy_pairs.map do |galaxy_pair|
  x1 = galaxy_pair.first.first
  x2 = galaxy_pair.last.first
  y1 = galaxy_pair.first.last
  y2 = galaxy_pair.last.last

  distance = (x2 - x1).abs + (y2 - y1).abs

  expandable_rows.each do |row_number|
    range = [x1, x2].sort
    distance += 999999 if row_number.between?(*range)
  end

  expandable_columns.each do |column_number|
    range = [y1, y2].sort
    distance += 999999 if column_number.between?(*range)
  end

  distance
end

puts shortest_paths.reduce(&:+)
