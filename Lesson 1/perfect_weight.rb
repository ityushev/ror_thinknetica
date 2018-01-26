print "Введите ваше имя "
name = gets.chomp.capitalize

print "Введите ваш рост "
height = gets.chomp.to_i

perfect_weight = height - 110

if perfect_weight > 0
  puts "#{name}, ваш идеальный вес - #{perfect_weight} кг"
else  
  puts "#{name}, ваш вес уже оптимальный"
end
