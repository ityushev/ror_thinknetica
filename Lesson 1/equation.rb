print "Коэффициент a = "
a = gets.to_f

print "Коэффициент b = "
b = gets.to_f

print "Коэффициент c = "
c = gets.to_f

if a == 0
	puts "Уравнение не квадратное, введите корректные коэффициенты"
else
	d = b**2 - 4*a*c

	puts "Дискриминант = #{d}"

	if d < 0
		puts "Корней нет"
	elsif d == 0
		puts "x1 = x2 = #{-b/(2*a)}"
	else
		puts "x1 = #{-b+Math.sqrt(d)/(2*a)}"
		puts "x2 = #{-b-Math.sqrt(d)/(2*a)}"
	end
end


