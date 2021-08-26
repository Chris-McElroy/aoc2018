# frozen_string_literal: true

require './helpers'

wires = word_list(3, ',')
wire1 = { C2.new(0, 0) => 0 }
last = C2.new(0, 0)
for vector in wires[0]
  dir = dir_from_udlr(vector[0])
  vector[1..-1].to_i.times do
    last += dir
    wire1[last.h] = wire1.size
  end
end

last = C2.new(0, 0)
wire2_dist = 0
min1 = 100000000
min2 = 100000000
for vector in wires[1]
  dir = dir_from_udlr(vector[0])
  vector[1..-1].to_i.times do
    last += dir
    wire1_dist = wire1[last.h]
    wire2_dist += 1
    min1 = min(last.manhattan_distance, min1) unless wire1_dist.nil?
    min2 = min(wire1_dist + wire2_dist, min2) unless wire1_dist.nil?
  end
end

p min1, min2
