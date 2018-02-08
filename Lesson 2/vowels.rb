vowels_array = ['a', 'e', 'i', 'o', 'u']
vowels_hash = {}

('a'..'z').each.with_index(1) do |letter, index|
  if vowels_array.include? letter
    vowels_hash[letter] = index
  end
end
