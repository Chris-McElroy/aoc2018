# frozen_string_literal: true

require './helpers'

def input1
  1
end

def input2
  5
end

def print_output(output)
  p output if output != 0
end

run_intcode(intcode(5), :input1, :print_output)
run_intcode(intcode(5), :input2, :print_output)

# 16434972
# 16694270
