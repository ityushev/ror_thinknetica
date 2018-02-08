months = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
total_days = 0
has_error = false

puts "Введите день"
user_day = gets.chomp.to_i

puts "Введите месяц"
user_month = gets.chomp.to_i

puts "Введите год"
user_year = gets.chomp.to_i

if (user_year % 4 == 0) && (user_year % 100 != 0) || (user_year % 400 == 0)
  months[1] = 29
end

if (months[user_month - 1] == nil) || (user_day < 1) || (user_day > months[user_month - 1])
  puts "Введена некорректная дата"
  exit
end
 
months.each.with_index do |days, month_index|
  if month_index == user_month - 1
    total_days += user_day
    break
  else
    total_days += days
  end
end

puts "Total days: #{total_days}"
