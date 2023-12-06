require_relative 'advent_data'

data = AdventData.new(day: 6, session: ARGV[0]).get

race_time = data.first.scan(/\d+/).join.to_i
record_distance = data.last.scan(/\d+/).join.to_i

ways_to_win = 0

(1...race_time).each do |seconds|
  speed = seconds
  time = race_time - seconds
  distance = speed * time

  ways_to_win += 1 if distance > record_distance
end

puts ways_to_win
