require_relative 'advent_data'

data = AdventData.new(day: 2, session: ARGV[0]).get

game_powers = data.map do |game_string|
  game, sets = game_string.split(':')
  game_id = game.scan(/\d+/).first.to_i
  sets = sets.split(';')

  set_possible_conditions = { 'red' => 0, 'green' => 0, 'blue' => 0 }

  sets.each do |set|
    set = set.split(',')

    set_possible_conditions.each do |colour, number|
      cubes = set.grep(/#{colour}/)

      if cubes.any?
        number_of_cubes = cubes.first.scan(/\d+/).first.to_i
        set_possible_conditions[colour] = number_of_cubes if number_of_cubes > number
      end
    end
  end
  
  set_possible_conditions.values.reduce(:*)
end

puts game_powers.sum
