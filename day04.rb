# frozen_string_literal: true

require './helpers'

range = int_word_line(4, '-')
working1 = 0
working2 = 0
n = range[0]

def next_increasing(n)
  n_digits = n.to_s.chars.map(&:to_i)
  mult = 11111
  mod = 100000
  for i in (0..4)
    return n + (n_digits[i] * mult) - (n % mod) if n_digits[i] > n_digits[i + 1]
    mod /= 10
    mult -= mod
  end
  n
end

def pairs?(n_digits, part1)
  for (d, i) in n_digits[0..4].each_with_index
    return true if n_digits[i + 1] == d && (part1 || n_digits[i - 1] != d && n_digits[i + 2] != d)
  end
  false
end

loop do
  n = next_increasing(n)
  break if n > range[1]
  n_digits = n.to_s.chars.map(&:to_i)
  working1 += 1 if pairs?(n_digits, true)
  working2 += 1 if pairs?(n_digits, false)
  n += 1
end

p working1, working2

# 2081
# 1411
