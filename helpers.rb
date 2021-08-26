# frozen_string_literal: true

def string_list(day)
  File.open("input#{day < 10 ? 0 : ''}#{day}").read.lines.map(&:chomp)
end

def string_line(day)
  string_list(day)[0]
end

def word_list(day, separator = '\n')
  string_list(day).map { |line| line.split(separator) }
end

def word_line(day, separator = '\n')
  word_list(day, separator)[0]
end

def word_single(day, separator = '\n')
  word_line(day, separator)[0]
end

def int_list(day)
  string_list(day).map(&:to_i)
end

def int_word_list(day, separator = '\n')
  word_list(day, separator).map { |line| line.map(&:to_i) }
end

def int_word_line(day, separator = '\n')
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

def dir_from_udlr(letter)
  c2_directions = {
    'U' => C2.new(0, 1), 'D' => C2.new(0, -1), 'L' => C2.new(-1, 0), 'R' => C2.new(1, 0)
  }
  c2_directions[letter]
end

def dir_from_nsew(letter)
  c2_directions = {
    'N' => C2.new(0, 1), 'S' => C2.new(0, -1), 'E' => C2.new(1, 0), 'W' => C2.new(-1, 0)
  }
  c2_directions[letter]
end

def run_intcode(code)
  line = 0
  while code[line] != 99
    case code[line]
    when 1..2
      code[code[line + 3]] = arithmetic_op(code, line)
      line += 4
    end
  end
  code[0]
end

def arithmetic_op(code, line)
  param1 = code[line + 1] < code.size ? code[code[line + 1]] : 0
  param2 = code[line + 2] < code.size ? code[code[line + 2]] : 0
  case code[line]
  when 1
    param1 + param2
  when 2
    param1 * param2
  end
end

def min(a, b)
  a < b ? a : b
end

def max(a, b)
  a > b ? a : b
end
