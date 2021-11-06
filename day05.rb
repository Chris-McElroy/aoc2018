require './helpers'

input = string_line(5)

def reduce(s)
  past = ''

  for i in 0..(s.size - 1)
    if !past.empty? && (past[-1].ord - s[i].ord).abs == 32
      past = past.chop
    else
      past << s[i]
    end
  end

  past.size
end

p reduce(input)

options = []
for l in 'a'..'z'
  subS = ''
  for c in input.each_char
    if c.ord != l.ord && (c.ord - l.ord).abs != 32
      subS << c
    end
  end
  options << reduce(subS)
end

p options
p options.min

# 10251 most recent answer

# reactionSites = []

# for i in 0..(input.size - 2)
#   if (input[i].ord - input[i + 1].ord).abs == 32
#     reactionSites << i
#   end
# end

# until reactionSites == []
#   p reactionSites.size
#   i = reactionSites.pop
#   next if (input[i].ord - input[i + 1].ord).abs != 32
#   input = (input[0..(i-1)] || '') + (input[(i+2)..(input.size-1)] || '')
#   if i > 0 && i <= input.size - 1 && (input[i-1].ord - input[i].ord).abs == 32
#     reactionSites << i - 1
#   end
#   for r in 0..(reactionSites.size - 1)
#     if reactionSites[r] >= i
#       reactionSites[r] -= 2
#     end
#   end
# end

# until reactions.zero?
#   reactions = 0
#   for i in 0..(input.size - 2)
#     # p input[i]
#     # p input[i].ord - input[i + 1].ord
#     if (input[i].ord - input[i + 1].ord).abs == 32
#       reactions += 1
#       input = (input[0..(i-1)] || '') + (input[(i+2)..(input.size-1)] || '')
#       break
#     end
#   end
# end

# p reactions
# p input.size

# 16434972
# 16694270
