require_relative 'advent_data'

data = AdventData.new(day: 2, session: ARGV[0]).get

possible_game_ids =* (1..data.length)
possible_conditions = { 'red' => 12, 'green' => 13, 'blue' => 14 }

data.each do |game_string|
  game, sets = game_string.split(':')
  game_id = game.scan(/\d+/).first.to_i
  sets = sets.split(';')

  sets.each do |set|
    set = set.split(',')

    possible_conditions.each do |colour, number|
      cubes = set.grep(/#{colour}/)
      
      if cubes.any?
        number_of_cubes = cubes.first.scan(/\d+/).first.to_i
        possible_game_ids.delete(game_id) if number_of_cubes > number
      end
    end
  end
end

puts possible_game_ids.sum
