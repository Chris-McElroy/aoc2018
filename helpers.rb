# frozen_string_literal: true

def string_list(day)
  File.open("input#{day < 10 ? 0 : ''}#{day}").read.lines.map(&:chomp)
end

def string_line(day)
  string_list(day)[0]
end

def word_list(day)
  string_list(day).map(&:split)
end

def word_line(day)
  word_list(day)[0]
end

def word_single(day)
  word_line(day)[0]
end

def int_list(day)
  string_list(day).map(&:to_i)
end

def int_word_list(day)
  word_list(day).map { |line| line.map(&:to_i) }
end

def int_line(day)
  word_line(day).map(&:to_i)
end

def int_single(day)
  int_list(day)[0]
end

# two dimensional coordinate structs
class C2
  attr_accessor :x, :y

  def initialize(x_in, y_in)
    @x = x_in
    @y = y_in
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
