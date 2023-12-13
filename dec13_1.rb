require_relative 'advent_data'

def find_reflection(image, coefficient)
  local_result = 0
  up_length = 0

  image.each_with_index do |line, index|
    up_length += 1
    down_length = image.length - up_length
    check_length = [up_length, down_length].min

    mirror = check_length == 0 ? false : true

    (0...check_length).each do |step|
      unless image[index - step].join == image[index + step + 1]&.join
        mirror = false
        break
      end
    end

    if mirror
      local_result = up_length * coefficient
      break
    end
  end

  local_result
end

data = AdventData.new(day: 13, session: ARGV[0]).get

split_data = [[]]

data.each do |line|
  line.empty? ? split_data << [] : split_data.last << line.chars
end

result = 0

split_data.each do |image|
  result += find_reflection(image, 100)

  rows = image.transpose

  result += find_reflection(rows, 1)
end

puts result
