# frozen_string_literal: true

require './helpers'

modules = int_list(1)

fuel1 = 0
fuel2 = 0

for m in modules
  fuel1 += m / 3 - 2

  while m > 5
    m = m / 3 - 2
    fuel2 += m
  end
end

puts fuel1, fuel2
# 3563458
# 5342292
