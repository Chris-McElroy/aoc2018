# frozen_string_literal: true

require './helpers'
require 'set'

input = string_list(2)

twoReps = 0
threeReps = 0

for word in input
  twoReps += 1 if word.each_char.detect { |e| word.count(e) == 2 }
  threeReps += 1 if word.each_char.detect { |e| word.count(e) == 3 }
end

p twoReps * threeReps

for i in 0..input[0].size
  smallWords = Set.new
  for word in input
    smallWord = (word[0..(i - 1)] || '') + (word[(i + 1)..(word.size - 1)] || '')
    p smallWord if smallWords.include? smallWord
    smallWords << smallWord
  end
end
