vowels_array = ["a", "e", "i", "o", "u"]
vowels_hash = Hash.new

i = 1
("a".."z").each do |letter|
  if vowels_array.include? letter
    vowels_hash[letter] = i
  end
  i += 1
end
