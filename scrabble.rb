#!/usr/bin/ruby

class Trie
  def initialize
    @nodes = Hash.new {|h,k| h[k] = Trie.new}
    @data  = Array.new
  end

  def add(str, path = nil)
    path = self.to_path(path || str)

    if path.empty?
      @data.push(str)  unless @data.include? str
    else
      @nodes[path.pop].add str, path
    end

    self
  end

  def find(path, found = [])
    path = self.to_path path

    if path.empty?
      @data + found
    else
      @nodes[path.pop].find(path, @data + found)
    end
  end

  def find_all(path)
    path = self.to_path path
    found = []

    until path.empty?
      found += find path.clone
      path.pop
    end

    found
  end

  protected
  def self.to_path(str)
    if str.is_a? Array
      str
    else
      str.downcase.each_char.to_a.sort.uniq
    end
  end
end

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
# Returns how much points you would get for the word
#
def build_dict
  trie = Trie.new
  File.open('dict.txt').each_line.to_a.map!(&:strip).each {|w| trie.add w }
  
  trie
end

DICT = build_dict

#
# Select words which contains every specified letter
#
def by_letters(letters)
  DICT.find letters
end

#
# List of appropriate words sorted by score
#
def best_words(letters)
  by_letters(letters).sort! {|x,y| score(x) <=> score(y) }
end
