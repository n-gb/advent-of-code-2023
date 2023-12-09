require_relative 'advent_data'

data = AdventData.new(day: 9, session: ARGV[0]).get

sequence_lists = []

next_values = data.map do |line|
  latest_sequence = line.split(' ').map(&:to_i)
  sequence_lists << []
  sequence_list = sequence_lists.last
  sequence_list << latest_sequence

  while latest_sequence.uniq != [0] do
    sequence_list << []

    sequence_start = latest_sequence[0]

    (1...latest_sequence.length).each do |index|
      if index == 1
        sequence_list.last << latest_sequence[index] - sequence_start
      else
        sequence_list.last << latest_sequence[index] - latest_sequence[index - 1]
      end
    end

    latest_sequence = sequence_list.last
  end

  sequence_list.last << 0

  (sequence_list.length - 1).downto(1).each do |index|
    previous_value = sequence_list[index - 1].first - sequence_list[index].first
    sequence_list[index - 1].unshift(previous_value)
  end

  sequence_list.first.first
end

puts next_values.reduce(&:+)
