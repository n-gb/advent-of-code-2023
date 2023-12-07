require_relative 'advent_data'

data = AdventData.new(day: 7, session: ARGV[0]).get

CARD_STRENGTH = {
  'J' => 1,
  '2' => 2,
  '3' => 3,
  '4' => 4,
  '5' => 5,
  '6' => 6,
  '7' => 7,
  '8' => 8,
  '9' => 9,
  'T' => 10,
  'Q' => 12,
  'K' => 13,
  'A' => 14
}

hand_lists_by_type = { five: [], four: [], full: [], three: [], two: [], one: [], high: [] }

data.each do |hand_and_bid|
  hand, bid = hand_and_bid.split(' ')
  cards_in_hand = hand.chars.tally
  jokers_count = cards_in_hand.delete('J').to_i

  case cards_in_hand.count
  when 0
    # Five jokers
    hand_lists_by_type[:five] << [hand, bid]
  when 1
    # Five of a kind
    hand_lists_by_type[:five] << [hand, bid]
  when 2
    # Four of a kind
    hand_lists_by_type[:four] << [hand, bid] if (cards_in_hand.values.max + jokers_count) == 4
    # Full house
    hand_lists_by_type[:full] << [hand, bid] if (cards_in_hand.values.max + jokers_count) == 3
  when 3
    # Three of a kind
    hand_lists_by_type[:three] << [hand, bid] if (cards_in_hand.values.max + jokers_count) == 3
    # Two pair
    hand_lists_by_type[:two] << [hand, bid] if (cards_in_hand.values.max + jokers_count) == 2
  when 4
    # One pair
    hand_lists_by_type[:one] << [hand, bid]
  when 5
    # High card
    hand_lists_by_type[:high] << [hand, bid]
  end
end

sorted_hand_list = []

hand_lists_by_type.values.each do |hand_type_list|
  sorted_hand_list += hand_type_list.sort! do |hand_and_bid_1, hand_and_bid_2|
    hand_1, bid_1 = hand_and_bid_1
    hand_2, bid_2 = hand_and_bid_2

    char_1_value = 0
    char_2_value = 0

    hand_1.chars.each_with_index do |card, index|
      unless card == hand_2[index]
        char_1_value = CARD_STRENGTH[card]
        char_2_value = CARD_STRENGTH[hand_2[index]]
        break
      end
    end

    char_2_value <=> char_1_value
  end
end

winnings = []

sorted_hand_list.each_with_index do |hand_and_bid, index|
  hand, bid = hand_and_bid
  rank = sorted_hand_list.length - index
  winnings << bid.to_i * rank
end

puts winnings.reduce(:+)
