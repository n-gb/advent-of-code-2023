require_relative 'advent_data'

data = AdventData.new(day: 8, session: ARGV[0]).get

instructions = data.first
nodes = data.drop(2)

hash_of_nodes = {}
root_node_names = []

nodes.each do |node|
  node_name, left, right = node.scan(/\w+/)
  hash_of_nodes[node_name] = [left, right]

  root_node_names << node_name if node_name.chars.last == 'A'
end

current_node_names = root_node_names
steps = 0
cycles = []

while current_node_names.any? do
  instructions.chars.each do |instruction|
    next_node_names = []
    steps += 1

    current_node_names.each do |node_name|
      case instruction
      when 'L'
        node_name = hash_of_nodes[node_name].first
      when 'R'
        node_name = hash_of_nodes[node_name].last
      end

      node_name.chars.last == 'Z' ? cycles << steps : next_node_names << node_name
    end

    current_node_names = next_node_names
  end
end

puts cycles.reduce(1, :lcm)
