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

#
# Dictionary of words that can be used in scrabble
#
DICT = File.open('dict.txt').each_line.to_a.map!(&:strip)

#
# Returns how much points you would get for the word
#
def score(word)
  word.each_char.to_a.map {|c| POINTS[c.to_sym] }.inject(:+)
end

#
# Select words which contains every specified letter
# TODO: memoize sort steps in data-structure similar to Trie
#
def by_letters(letters)
  result = DICT
  letters.each_char {|l| result.select! {|w| w.include? l } }

  result
end

#
# List of appropriate words sorted by score
#
def best_words(letters)
  by_letters(letters).sort! {|x,y| score(x) <=> score(y) }
end
