#!/usr/bin/ruby

#
# Convert human-readable list of the scores per letter
# into the hash of the following format:
#   letter => score
#
POINTS = Hash[{
  0  => [:blank],
  1  => [:a, :e, :i, :l, :n, :o, :r, :s, :t, :u],
  2  => [:d, :g],
  3  => [:b, :c, :m, :p],
  4  => [:f, :h, :v, :w, :y],
  5  => [:k],
  8  => [:j, :x],
  10 => [:q, :z]
}.invert.map {|k,v| k.zip [v].cycle }.flatten(1)]

def score(word)
  word.each_char.to_a.map {|c| POINTS[c.to_sym] }.inject(:+)
end
