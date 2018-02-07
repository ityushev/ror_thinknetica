fibonacci = [0, 1]

loop do
  new_number = fibonacci[-1] + fibonacci[-2]
  break if new_number >= 100
  fibonacci << new_number
end
