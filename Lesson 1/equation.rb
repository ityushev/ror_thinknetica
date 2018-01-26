print "Коэффициент a = "
a = gets.to_f

print "Коэффициент b = "
b = gets.to_f

print "Коэффициент c = "
c = gets.to_f

# b и c могут быть равны нулю, a - не может по определению квадратного уравнения,
# поэтому проверяем только a
if a == 0
  puts "Уравнение не квадратное, введите корректные коэффициенты"
else
  d = b**2 - 4 * a * c

  puts "Дискриминант = #{d}"

  if d < 0
    puts "Корней нет"
  elsif d == 0
    puts "x1 = x2 = #{-b/(2 * a)}"
  else
    discriminant_root = Math.sqrt(d)
    puts "x1 = #{-b + discriminant_root/(2 * a)}"
    puts "x2 = #{-b - discriminant_root/(2 * a)}"
  end
end
