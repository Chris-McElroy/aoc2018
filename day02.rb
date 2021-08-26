# frozen_string_literal: true

require './helpers'

program = intcode(2)
program[1] = 12
program[2] = 2
p run_intcode(program)

input = 0
while input < 10_000
  program = intcode(2)
  program[1] = input / 100
  program[2] = input % 100
  if run_intcode(program) == 19_690_720
    p input
    break
  end
  input += 1
end

# 3931283
# 6979
