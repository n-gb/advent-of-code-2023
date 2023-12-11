require_relative 'advent_data'

data = AdventData.new(day: 11, session: ARGV[0]).get

mapped_data = data.map { |line| line.chars }

expanded_data = mapped_data
index = 0

# expand by rows
while index < expanded_data.length do
  if expanded_data[index].uniq == ['.']
    expanded_data.insert(index + 1, expanded_data[index])
    index += 1
  end
  index += 1
end

expanded_data = expanded_data.transpose
index = 0

# expand by columns
while index < expanded_data.length do
  if expanded_data[index].uniq == ['.']
    expanded_data.insert(index + 1, expanded_data[index])
    index += 1
  end
  index += 1
end

expanded_data = expanded_data.transpose
galaxy_coordinates = []

expanded_data.each_with_index do |row, i|
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

  (x2 - x1).abs + (y2 - y1).abs
end

p shortest_paths.reduce(&:+)
