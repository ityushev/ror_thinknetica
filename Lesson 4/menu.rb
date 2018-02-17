require_relative "station"
require_relative "train"
require_relative "passenger_train"
require_relative "cargo_train"
require_relative "route"
require_relative "vagon"
require_relative "cargo_vagon"
require_relative "passenger_vagon"
require_relative "handler"

class Menu
  ACTIONS =  [
    "Создать станцию",
    "Создать поезд",
    "Создать маршрут",
    "Добавить станцию в маршрут",
    "Удалить станцию из маршрута",
    "Назначить маршрут поезду",
    "Добавить вагон к поезду",
    "Отцепить вагон от поезда",
    "Переместить поезд",
    "Вывести список станций и список поездов на станциях",
    "Вывести список поездов"
  ]

  TRAIN_TYPES = { "pass" => "PassengerTrain", "cargo" => "CargoTrain" }
  INDENT = "- "

  def initialize(handler)
    @handler = handler
  end

  def draw
    actions_list
    request_action
  end

  private

  attr_reader :handler

  def show_message(text)
    puts "#{INDENT}#{text}"
  end

  def actions_list
    ACTIONS.each.with_index(1) { |action, i| puts "#{i}. #{action}" }
  end

  def train_types_list
    TRAIN_TYPES.each { |code, type| puts "#{code}: #{type}"}
  end

  def create_station
    show_message("Введите название станции")
    station_name = gets.chomp

    if station_name.length == 0
      show_message("Ошибка, введено некорректное название")
      return
    end

    if handler.stations.any? { |station| station.name == station_name } 
      show_message("Ошибка, такая станция уже создана")
      return
    end

    handler.create_station(station_name)
  end

  def create_train
    show_message("Введите номер поезда")
    train_number = gets.chomp
    
    if train_number.length == 0
      show_message("Ошибка, введен некорректный номер")
      return
    end

    if handler.trains.any? { |train| train.number == train_number } 
      show_message("Ошибка, такой поезд уже создан")
      return
    end

    show_message("Выберите тип поезда")
    train_types_list
    train_type = TRAIN_TYPES[gets.chomp]

    if train_type.nil?
      show_message("Ошибка, введен некорректный тип поезда")
      return
    end

    handler.create_train(train_number, train_type)
  end

  def create_route
    if handler.stations.size < 2
      show_message("Ошибка, должно быть создано минимум 2 станции")
      return
    end

    show_message("Доступные станции:")
    view_list(handler.stations)

    show_message("Выберите начальную станцию")
    from = gets.chomp.to_i
    
    return unless station_exists?(from)

    show_message("Выберите конечную станцию")
    to = gets.chomp.to_i

    return unless station_exists?(to)

    if from == to
      show_message("Ошибка, выберите разные станции")
      return
    end

    handler.create_route(from, to)
  end

  def add_station_to_route
    show_message("Выберите маршрут:")
    view_list(handler.routes)
    route_index = gets.chomp.to_i
    return unless route_exists?(route_index)

    show_message("Выберите станцию:")

    free_stations = free_stations(route_index)

    view_list(free_stations)
    station = free_stations[gets.chomp.to_i]
    if station.nil?
      show_message("Ошибка! Выбрана некорректная станция")
      return
    end

    unless free_stations.include? station
      show_message("Ошибка! станция уже естьв маршруте")
      return
    end
    station_index = handler.stations.index(station)
    handler.add_station_to_route(route_index, station_index)
  end


  def free_stations(route_index)
    handler.stations - handler.routes[route_index].stations
  end

  def remove_station_from_route
    show_message("Выберите маршрут:")
    view_list(handler.routes)
    route_index = gets.chomp.to_i
    return unless route_exists?(route_index)

    show_message("Выберите станцию:")
    view_stations_in_route(route_index)
    station_index = gets.chomp.to_i
    return unless station_exists?(station_index)

    handler.remove_station_from_route(route_index, station_index)
  end

  def view_stations_in_route(route_index)
    view_list(handler.routes[route_index].stations)
  end

  def set_route
    if handler.trains.size == 0 || handler.routes.size == 0
      show_message("Не созданы поезда или маршруты")
      return
    end

    show_message("Выберите поезд:")
    view_list(handler.trains)
    train_index = gets.chomp.to_i
    return unless train_exists?(train_index)

    show_message("Выберите маршрут:")
    view_list(handler.routes)
    route_index = gets.chomp.to_i
    return unless route_exists?(route_index)

    handler.set_route(route_index, train_index)
  end

  def add_vagon
    show_message("Выберите поезд:")
    view_list(handler.trains)
    train_index = gets.chomp.to_i
    return unless train_exists?(train_index)

    if handler.trains[train_index].is_a? PassengerTrain
      vagon = PassengerVagon.new
    else 
      vagon = CargoVagon.new
    end

    handler.add_vagon(train_index, vagon)
  end

  def remove_vagon
    show_message("Выберите поезд:")
    view_list(handler.trains)
    train_index = gets.chomp.to_i
    return unless train_exists?(train_index)

    handler.remove_vagon(train_index)
  end

  def move_train
    show_message("Выберите поезд:")
    view_list(handler.trains)
    train_index = gets.chomp.to_i
    return unless train_exists?(train_index)

    show_message("Выберите направление: \"1\" - вперед. \"2\" - назад.")
    direction = gets.chomp.to_i

    case direction
    when 1 then handler.move_forward(train_index)
    when 2 then handler.move_back(train_index)
    else show_message("Ошибка")
    end
  end

  def view_stations
    handler.stations.each do |station|
      puts "Cтанция " + station.name
      if station.trains.size == 0
        puts "- На станции нет поездов"
      else
        puts "- Поезда:"
        station.trains.each do |train|
          puts train.number
        end
      end    
    end
  end

  def view_trains
    view_list(handler.trains)
  end

  def station_exists?(station)
    if handler.stations[station].nil?
      show_message("Ошибка, выбрана несуществующая станция")
      return false
    end
    true
  end

  def route_exists?(route)
    if handler.routes[route].nil?
      show_message("Ошибка, выбран несуществующий маршрут")
      return false
    end
    true
  end

  def train_exists?(train)
    if handler.trains[train].nil?
      show_message("Ошибка, выбран несуществующий поезд")
      return false
    end
    true
  end

  def station_in_route?(route, station)
    if handler.routes[route].stations[station].nil?
      return false
    end
    show_message("Ошибка, эта станция уже есть в маршруте")
    true
  end

  def view_list(list)
    list.each.with_index { |item, i| puts "#{i}. #{item}" }
  end

  def incorrect_action
    show_message("Ошибка! Некорректная команда!") 
  end

  def handle_action(action)
    case action
    when "1" then create_station
    when "2" then create_train
    when "3" then create_route
    when "4" then add_station_to_route
    when "5" then remove_station_from_route
    when "6" then set_route
    when "7" then add_vagon
    when "8" then remove_vagon
    when "9" then move_train
    when "10" then view_stations
    when "11" then view_trains
    when "help" then actions_list
    when "exit" then exit
    else incorrect_action
    end
  end

  def request_action
    loop do
      puts "----------------------"
      show_message("Введите код операции. help - список команд, exit - завершение программы")
      handle_action(gets.chomp)
    end
  end

end
