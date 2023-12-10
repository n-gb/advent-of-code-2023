require_relative 'advent_data'

def up_conditions_satisfied?(up)
  up == '|' || up == 'F' || up == '7' || up == 1
end

def right_conditions_satisfied?(right)
  right == '-' || right == '7' || right == 'J' || right == 1
end

def down_conditions_satisfied?(down)
  down == '|' || down == 'L' || down == 'J' || down == 1
end

def left_conditions_satisfied?(left)
  left == '-' || left == 'L' || left == 'F' || left == 1
end

def find_next_point(current_coordinates, loop_length, path_data)
  current_row = current_coordinates.first
  current_column = current_coordinates.last
  current_point = path_data[current_row][current_column]

  up_row = current_row - 1
  up_column = current_column
  up = up_row < 0 ? nil : path_data[up_row][up_column]

  down_row = current_row + 1
  down_column = current_column
  down = down_row == path_data.length ? nil : path_data[down_row][down_column]

  left_row = current_row
  left_column = current_column - 1
  left = left_column < 0 ? nil : path_data[left_row][left_column]

  right_row = current_row
  right_column = current_column + 1
  right = right_column == path_data[current_row].length ? nil : path_data[right_row][right_column]

  path_data[current_row][current_column] = loop_length

  case current_point
  when 'S'
    # up, right, down, left
    return [up_row, up_column] if up_conditions_satisfied?(up)
    return [right_row, right_column] if right_conditions_satisfied?(right)
    return [down_row, down_column] if down_conditions_satisfied?(down)
    return [left_row, left_column] if left_conditions_satisfied?(left)
  when '|'
    # up, down
    return [up_row, up_column] if up_conditions_satisfied?(up)
    return [down_row, down_column] if down_conditions_satisfied?(down)
  when '-'
    # right, left
    return [right_row, right_column] if right_conditions_satisfied?(right)
    return [left_row, left_column] if left_conditions_satisfied?(left)
  when 'L'
    # up, right
    return [up_row, up_column] if up_conditions_satisfied?(up)
    return [right_row, right_column] if right_conditions_satisfied?(right)
  when 'J'
    # up, left
    return [up_row, up_column] if up_conditions_satisfied?(up)
    return [left_row, left_column] if left_conditions_satisfied?(left)
  when 'F'
    # down, right
    return [down_row, down_column] if down_conditions_satisfied?(down)
    return [right_row, right_column] if right_conditions_satisfied?(right)
  when '7'
    # down, left
    return [down_row, down_column] if down_conditions_satisfied?(down)
    return [left_row, left_column] if left_conditions_satisfied?(left)
  end
end

data = AdventData.new(day: 10, session: ARGV[0]).get

mapped_data = []
starting_coordinates = []

data.each_with_index do |line, index|
  starting_column = line.index('S')
  starting_coordinates = [index, starting_column] if starting_column
  mapped_data << line.chars
end

path_data = mapped_data

loop_length = 1
path = [starting_coordinates]
current_coordinates = find_next_point(starting_coordinates, loop_length, path_data)

while current_coordinates != starting_coordinates do
  loop_length += 1
  path << current_coordinates
  current_coordinates = find_next_point(current_coordinates, loop_length, path_data)
end

# Shoelace formula
sum = path[path.length - 1].first * path[0].last - path[0].first * path[path.length - 1].last

(0...path.length - 1).each do |i|
  sum += (path[i].first * path[i + 1].last) - (path[i].last * path[i + 1].first)
end

area = sum.abs / 2

# Pick's theorem
enclosed_tiles = area - path.length / 2 + 1

puts enclosed_tiles
