require_relative 'advent_data'

data = AdventData.new(day: 4, session: ARGV[0]).get

won_scratchcards = []

data.each do |card|
  card_number, numbers = card.split(':')
  card_number = card_number.scan(/\d+/).first.to_i
  winning_numbers, present_numbers = numbers.split('|')
  winning_numbers = winning_numbers.scan(/\d+/).map(&:to_i)
  present_numbers = present_numbers.scan(/\d+/).map(&:to_i)
  present_winning_numbers = winning_numbers & present_numbers
  number_of_present_winning_numbers = present_winning_numbers.count

  next if number_of_present_winning_numbers == 0

  (won_scratchcards.count(card_number) + 1).times do
    for i in 1..number_of_present_winning_numbers do
      won_scratchcards << (card_number + i)
    end
  end
end

puts data.count + won_scratchcards.count
