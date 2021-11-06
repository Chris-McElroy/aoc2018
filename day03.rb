# frozen_string_literal: true

require './helpers'

input = word_list(3)

fabric = Array.new
width = 1200

for _ in 1..width
  fabric << Array.new(width, 0)
end

for req in input
  #1 @ 45,64: 22x22
  dim = req[3].split('x').map { |e| e.to_i }
  start = req[2].split(/,|:/).map { |e| e.to_i }
  
  for x in start[0]..(start[0] + dim[0] - 1)
    for y in start[1]..(start[1] + dim[1] - 1)
      fabric[x][y] += 1
    end
  end

end
  
total = 0
for x in 0..(width-1)
  for y in 0..(width - 1)
    total += 1 if fabric[x][y] > 1
  end
end

for req in input
  #1 @ 45,64: 22x22
  dim = req[3].split('x').map { |e| e.to_i }
  start = req[2].split(/,|:/).map { |e| e.to_i }

  intact = true
  for x in start[0]..(start[0] + dim[0] - 1)
    for y in start[1]..(start[1] + dim[1] - 1)
      intact = false unless fabric[x][y] == 1
    end
  end
  p req if intact

end

# for line in fabric
#   p line

# end

p total