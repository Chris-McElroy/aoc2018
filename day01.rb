# frozen_string_literal: true

input = File.open('input01').read.chomp.lines.map(&:to_i)

sum1 = 0
sum2 = 0

input.each do |m|
  sum1 += m / 3 - 2

  while m > 5
    m = m / 3 - 2
    sum2 += m
  end
end

puts sum1, sum2
# 3563458
# 5342292
