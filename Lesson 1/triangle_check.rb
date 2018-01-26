print "Длина первой стороны "
a = gets.to_f

print "Длина второй стороны "
b = gets.to_f

print "Длина третьей стороны "
c = gets.to_f

if a <= 0 || b <= 0 || c <= 0
  puts "Введите корректные данные" 
else
  sides = [a, b, c].sort.reverse
  
  if sides[0]**2 == sides[1]**2 + sides[2]**2
    output_string = "Треугольник - прямоугольный"
    if sides[1] == sides[2]
      output_string += " и равнобедренный"
    end
  elsif sides[0] == sides[1] && sides[0] == sides[2]
    output_string = "Треугольник - равносторонний"
  elsif sides[0] == sides[1] || sides[1] == sides[2]
    output_string = "Треугольник - равнобедренный"
  else
    output_string = "Треугольник - не прямоугольный, не равнобедренный и не равносторонний"
  end

  puts output_string  
end
