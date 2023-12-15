require_relative 'advent_data'

def find_box_num(string, current_value = 0)
  string.each_byte do |char|
    current_value += char
    current_value *= 17
    current_value %= 256
  end

  current_value
end

data = AdventData.new(day: 15, session: ARGV[0]).get.first

hash_map = []
256.times { hash_map << {} }

data.split(',').each do |string|
  current_value = 0
  if string.include?('-')
    label = string.chop
    box = find_box_num(label)
    hash_map[box].delete(label)
  elsif string.include?('=')
    label, focal_length = string.split('=')
    box = find_box_num(label)
    hash_map[box][label] = focal_length.to_i
  end
end

focusing_power = 0

hash_map.each_with_index do |box, number|
  box.each_with_index do |lense, slot|
    focusing_power += (number + 1) * (slot + 1) * lense.last
  end
end

puts focusing_power
