print "Введите ваше имя "
name = gets.chomp
name.capitalize!

print "Введите ваш рост "
height = gets.chomp

perfect_weight = height.to_i - 110

if perfect_weight > 0
	puts "#{name}, ваш идеальный вес - #{perfect_weight} кг"
else	
	puts "#{name}, ваш вес уже оптимальный"
end
