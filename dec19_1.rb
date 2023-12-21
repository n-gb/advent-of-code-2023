require_relative 'advent_data'

def evaluate_part(x, m, a, s, workflow_rules)
  next_workflow_name = ''

  workflow_rules.each do |rule|
    if eval(rule[:condition])
      next_workflow_name = rule[:next]
      break
    end
  end

  case next_workflow_name
  when 'A'
    true
  when 'R'
    false
  else
    evaluate_part(x, m, a, s, @workflow_hash[next_workflow_name])
  end
end

data = AdventData.new(day: 19, session: ARGV[0]).get

workflows, part_ratings = data.slice_before('').to_a
part_ratings.shift

@workflow_hash = {}

workflows.each do |workflow|
  workflow_name, rules = workflow.split('{')
  @workflow_hash[workflow_name] = []

  rules = rules.chop.split(',')

  rules.each do |rule|
    condition, next_workflow = rule.split(':')

    if next_workflow.nil?
      next_workflow = condition
      condition = 'true'
    end

    @workflow_hash[workflow_name] << { condition: condition, next: next_workflow }
  end
end

accepted_parts = []

part_ratings.each do |part_rating|
  x, m, a, s = eval(part_rating.tr('{}', ''))

  accepted_parts << part_rating if evaluate_part(x, m, a, s, @workflow_hash['in'])
end

combined_ratings = 0
accepted_parts.each { |accepted_part| combined_ratings += accepted_part.scan(/\d+/).map(&:to_i).reduce(:+) }

puts combined_ratings
