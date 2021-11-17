# frozen_string_literal: true

require './helpers'
require 'set'

input = int_list(1)

size = input.size
current = 0
allValues = Set.new
i = 0
initials = []

until allValues.include? current
  allValues << current
  current += input[i % size]
  i += 1
  p current if i == size
end

p current

current = 0
for change in input
  initials << current
  current += change
end

p ''
p current
mods = []
answer = 0
stepsToAnswer = 1000000000

for i in 0..(size - 1)
  for j in 0..(i - 1)
    next unless mods[j] == initials[i] % current
    goesToI = (initials[i] > initials[j]) == current.positive?
    newSteps = ((initials[i] - initials[j]) / current).abs * size + (goesToI ? i : j)
    answer = initials[goesToI ? i : j] if newSteps < stepsToAnswer
  end
  mods << (initials[i] % current)
end

p answer

# 508
# 549
