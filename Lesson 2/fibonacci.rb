fibonacci = [0, 1]

while (new_number = fibonacci[-1] + fibonacci[-2]) <= 100
  fibonacci << new_number
end
