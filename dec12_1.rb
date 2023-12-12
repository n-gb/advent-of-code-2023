require_relative 'advent_data'

def all_groups_present?(found_row, groups)
  found_row.split('.').reject(&:empty?) == groups.map { |group_num| '#' * group_num }
end

def find_springs(row, groups, found_row = '')
  if row.empty?
    @arrangements_number += 1 if all_groups_present?(found_row, groups)
  else
    case row[0]
    when '.'
      find_springs(row[1..], groups, found_row + '.')
    when '#'
      find_springs(row[1..], groups, found_row + '#')
    when '?'
      find_springs(row[1..], groups, found_row + '.')
      find_springs(row[1..], groups, found_row + '#')
    end
  end
end

data = AdventData.new(day: 12, session: ARGV[0]).get

rows = []
groups_data = []

data.each do |line|
  row, groups = line.split(' ')
  rows << row
  groups_data << groups.split(',').map(&:to_i)
end

@arrangements_number = 0

rows.each_with_index do |row, index|
  groups = groups_data[index]

  find_springs(row, groups)
end

puts @arrangements_number
