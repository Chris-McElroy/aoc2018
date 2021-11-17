# frozen_string_literal: true

require './helpers'

input = word_list(4).sort
guard = 0
min = Hash.new
perMin = Array.new
for _ in 0..59
  perMin << Hash.new

end
slept = 0

for line in input
  if line.include? "Guard"
    guard = line[3].split('#')[1].to_i
  elsif line.include? "asleep"
    slept = line[1].split(/:|\]/)[1].to_i
  elsif line.include? "wakes"
    min[guard] = (min[guard] || 0) + line[1].split(/:|\]/)[1].to_i - slept
    for m in slept..(line[1].split(/:|\]/)[1].to_i - 1)
      perMin[m][guard] = (perMin[m][guard] || 0) + 1
    end
  end
end

bestGuard = min.max_by(&:last)[0]
p bestGuard

p perMin.each_with_index.max_by { |hash, _| (hash[bestGuard] || 0) }

p perMin.each_with_index.max_by { |hash, _| (hash.max_by(&:last) || [0,0])[1] }

# p min
# 283 * 460
