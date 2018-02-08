# Сумма покупок

items = Hash.new
total_price = 0

loop do
  puts "Введите название товара"
  item = gets.chomp
  
  break if item.downcase == "стоп"

  puts "Введите цену за единицу товара"
  price = gets.chomp.to_f

  puts "Введите количество товара"
  quantity = gets.chomp.to_f

  item_sum = price * quantity
  total_price += item_sum
  items[item] = {"Цена за единицу" => price, "Количество" => quantity, "Итоговая сумма" => item_sum}  
end

puts items
puts "Итоговая стоимость: #{total_price}"
