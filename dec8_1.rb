require_relative 'advent_data'

STARTING_NODE = 'AAA'.freeze
ENDING_NODE = 'ZZZ'.freeze

data = AdventData.new(day: 8, session: ARGV[0]).get

instructions = data.first
nodes = data.drop(2)

hash_of_nodes = {}

nodes.each do |node|
  node_name, left, right = node.scan(/\w+/)
  hash_of_nodes[node_name] = [left, right]
end

current_node_key = STARTING_NODE
current_node_lookup = hash_of_nodes[STARTING_NODE]
steps = 0

while current_node_key != ENDING_NODE do
  instructions.chars.each do |instruction|
    steps += 1

    case instruction
    when 'L'
      current_node_key = current_node_lookup.first
    when 'R'
      current_node_key = current_node_lookup.last
    end

    current_node_lookup = hash_of_nodes[current_node_key]
  end
end

puts steps
