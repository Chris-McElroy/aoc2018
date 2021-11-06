# frozen_string_literal: true

def string_list(day)
  File.open("input#{day < 10 ? 0 : ''}#{day}").read.lines.map(&:chomp)
end

def string_line(day)
  string_list(day)[0]
end

def word_list(day, separator = ' ')
  string_list(day).map { |line| line.split(separator) }
end

def word_line(day, separator = ' ')
  word_list(day, separator)[0]
end

def word_single(day, separator = ' ')
  word_line(day, separator)[0]
end

def int_list(day)
  string_list(day).map(&:to_i)
end

def int_word_list(day, separator = ' ')
  word_list(day, separator).map { |line| line.map(&:to_i) }
end

def int_word_line(day, separator = ' ')
  word_line(day, separator).map(&:to_i)
end

def int_single(day)
  int_list(day)[0]
end

def intcode(day)
  int_word_line(day, ',')
end

# two dimensional coordinate class
class C2
  attr_accessor :x, :y

  def initialize(x, y)
    @x = x
    @y = y
  end

  def adjacents
    [C2.new(-1, 0), C2.new(0, -1), C2.new(0, 1), C2.new(1, 0)].map { |a| C2.new(a.x + @x, a.y + @y) }
  end

  def neighbors
    [
      C2.new(-1, -1), C2.new(-1, 0), C2.new(-1, 1), C2.new(0, -1),
      C2.new(0, 1), C2.new(1, -1), C2.new(1, 0), C2.new(1, 1)
    ].map do |n|
      C2.new(n.x + @x, n.y + @y)
    end
  end

  def +(other)
    C2.new(other.x + @x, other.y + @y)
  end

  def rotate_left
    temp_x = @x
    @x = -@y
    @y = temp_x
  end

  def rotate_right
    temp_x = @x
    @x = @y
    @y = -temp_x
  end

  def manhattan_distance
    @x.abs + @y.abs
  end

  def h
    [@x, @y]
  end

  def ==(other)
    @x == other.x && @y == other.y
  end
end

def dir_from_udlr_hash
  { 'U' => C2.new(0, 1), 'D' => C2.new(0, -1), 'L' => C2.new(-1, 0), 'R' => C2.new(1, 0) }
end

def dir_from_nsew_hash
  { 'N' => C2.new(0, 1), 'S' => C2.new(0, -1), 'E' => C2.new(1, 0), 'W' => C2.new(-1, 0) }
end

def run_intcode(code, pull_input, push_output)
  line = 0
  while code[line] != 99
    op = code[line] % 100
    case op
    when 1..2
      code[code[line + 3]] = arithmetic_op(code, line)
    when 3
      code[code[line + 1]] = method(pull_input).call
    when 4
      method(push_output).call(code[line] > 100 ? code[line + 1] : code[code[line + 1]])
    when 5..6
      line = jump_op(code, line)
    when 7..8
      code[code[line + 3]] = equality_op(code, line)
    end
    line += [0, 4, 4, 2, 2, 0, 0, 4, 4][op]
  end
  code[0]
end

def arithmetic_op(code, line)
  param1, param2 = get_params(code, line)
  case code[line] % 100
  when 1
    param1 + param2
  when 2
    param1 * param2
  end
end

def jump_op(code, line)
  param1, param2 = get_params(code, line)
  if (code[line] % 100 == 6) == (param1.zero?)
    param2
  else
    line + 3
  end
end

def equality_op(code, line)
  param1, param2 = get_params(code, line)
  case code[line] % 100
  when 7
    param1 < param2 ? 1 : 0
  when 8
    param1 == param2 ? 1 : 0
  end
end

def get_params(code, line)
  param1 = code[line + 1]
  param2 = code[line + 2]
  if code[line] > 1000
    code[line] -= 1000
  else
    param2 = param2 < code.size ? code[param2] : 0
  end

  param1 = param1 < code.size ? code[param1] : 0 if code[line] < 100

  [param1, param2]
end

def min(a, b)
  a < b ? a : b
end

def max(a, b)
  a > b ? a : b
end
