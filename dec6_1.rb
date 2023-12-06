require_relative 'advent_data'

data = AdventData.new(day: 6, session: ARGV[0]).get

race_times = data.first.scan(/\d+/)
record_distances = data.last.scan(/\d+/)

ways_to_win = (0...race_times.length).map do |race_index|
  ways_to_win_race = 0

  (1..race_times[race_index].to_i).each do |seconds|
    speed = seconds
    time = race_times[race_index].to_i - seconds
    distance = speed * time

    ways_to_win_race += 1 if distance > record_distances[race_index].to_i
  end

  ways_to_win_race
end.flatten

puts ways_to_win.reduce(:*)
