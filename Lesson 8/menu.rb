require_relative 'station'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'route'
require_relative 'vagon'
require_relative 'cargo_vagon'
require_relative 'passenger_vagon'
require_relative 'handler'
require_relative 'validate'

class Menu
  include Validate

  ACTIONS = %(1. Создать станцию
2. Создать поезд
3. Создать маршрут
4. Добавить станцию в маршрут
5. Удалить станцию из маршрута
6. Назначить маршрут поезду
7. Добавить вагон к поезду
8. Отцепить вагон от поезда
9. Переместить поезд
10. Вывести список станций и список поездов на станциях
11. Вывести список поездов
12. Занять место (объем) в вагоне).freeze

  TRAIN_TYPES = { 'p' => PassengerTrain, 'c' => CargoTrain }.freeze
  INDENT = '- '.freeze

  def initialize(handler)
    @handler = handler
    validate!
  end

  def draw
    actions_list
    request_action
  end

  private

  attr_reader :handler

  def validate!
    raise 'Неверный тип объекта, ожидается Handler' unless handler.is_a? Handler
    true
  end

  def actions_list
    puts ACTIONS
  end

  def train_types_list
    TRAIN_TYPES.each { |code, type| puts "#{code}: #{type}" }
  end

  def create_station
    puts 'Введите название станции'
    station_name = gets.chomp

    raise 'Ошибка, такая станция уже создана!' if handler.stations.any? { |station| station.name == station_name }

    handler.create_station(station_name)
  rescue RuntimeError => e
    puts e.message
  end

  def create_train
    puts 'Введите номер поезда'
    train_number = gets.chomp

    raise 'Ошибка, такой поезд уже создан!' if handler.trains.any? { |train| train.number == train_number }

    puts 'Выберите тип поезда'
    train_types_list
    train_type = TRAIN_TYPES[gets.chomp]

    raise 'Ошибка, введен некорректный тип поезда' if train_type.nil?

    handler.create_train(train_number, train_type)

    puts "Создан поезд #{train_number}"
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def create_route
    raise 'Ошибка, должно быть создано минимум 2 станции' if handler.stations.size < 2

    puts 'Доступные станции:'
    view_list(handler.stations)

    puts 'Выберите начальную станцию'
    from = gets.chomp.to_i

    raise 'Ошибка, такой станции нет' unless station_exists?(from)

    puts 'Выберите конечную станцию'
    to = gets.chomp.to_i

    raise 'Ошибка, такой станции нет' unless station_exists?(to)
    raise 'Ошибка, выберите разные станции' if from == to

    handler.create_route(from, to)
  rescue RuntimeError => e
    puts e.message
  end

  def add_station_to_route
    puts 'Выберите маршрут:'
    view_list(handler.routes)
    route_index = gets.chomp.to_i

    raise 'Ошибка, выбран несуществующий маршрут' unless route_exists?(route_index)

    puts 'Выберите станцию:'

    free_stations = free_stations(route_index)
    raise 'Ошибка, для этого маршрута нет доступных станций' if free_stations.size.zero?

    view_list(free_stations)
    station = free_stations[gets.chomp.to_i]

    raise 'Ошибка, выбрана несуществующая станция' if station.nil?
    raise 'Ошибка, станция уже есть в маршруте' unless free_stations.include? station

    station_index = handler.stations.index(station)
    handler.add_station_to_route(route_index, station_index)
  rescue RuntimeError => e
    puts e.message
  end

  def free_stations(route_index)
    handler.stations - handler.routes[route_index].stations
  end

  def remove_station_from_route
    puts 'Выберите маршрут:'
    view_list(handler.routes)
    route_index = gets.chomp.to_i

    raise 'Ошибка, выбран несуществующий маршрут' unless route_exists?(route_index)

    puts 'Выберите станцию:'
    view_stations_in_route(route_index)
    station_index = gets.chomp.to_i

    raise 'Ошибка, выбрана несуществующая станция' if handler.routes[route_index].stations[station_index].nil?

    handler.remove_station_from_route(route_index, station_index)
  rescue RuntimeError => e
    puts e.message
  end

  def view_stations_in_route(route_index)
    view_list(handler.routes[route_index].stations)
  end

  def set_route
    raise 'Ошибка, не созданы поезда' if handler.trains.size.zero?
    raise 'Ошибка, не созданы маршруты' if handler.routes.size.zero?

    puts 'Выберите поезд:'
    view_list(handler.trains)
    train_index = gets.chomp.to_i

    raise 'Ошибка, выбран несуществующий поезд' unless train_exists?(train_index)

    puts 'Выберите маршрут:'
    view_list(handler.routes)
    route_index = gets.chomp.to_i

    raise 'Ошибка, выбран несуществующий маршрут' unless route_exists?(route_index)

    handler.set_route(route_index, train_index)
  rescue RuntimeError => e
    puts e.message
  end

  def add_vagon
    puts 'Выберите поезд:'
    view_list(handler.trains)
    train_index = gets.chomp.to_i

    raise 'Ошибка, выбран несуществующий поезд' unless train_exists?(train_index)

    if handler.trains[train_index].is_a? PassengerTrain
      puts 'Введите количество мест'
      vagon = PassengerVagon.new(gets.chomp.to_i)
    else
      puts 'Введите объем'
      vagon = CargoVagon.new(gets.chomp.to_i)
    end

    handler.add_vagon(train_index, vagon)
  rescue RuntimeError => e
    puts e.message
  end

  def remove_vagon
    puts 'Выберите поезд:'
    view_list(handler.trains)
    train_index = gets.chomp.to_i

    raise 'Ошибка, выбран несуществующий поезд' unless train_exists?(train_index)

    handler.remove_vagon(train_index)
  rescue RuntimeError => e
    puts e.message
  end

  def move_train
    puts 'Выберите поезд:'
    view_list(handler.trains)
    train_index = gets.chomp.to_i

    raise 'Ошибка, выбран несуществующий поезд' unless train_exists?(train_index)

    puts 'Выберите направление: "1" - вперед. "2" - назад.'
    direction = gets.chomp.to_i

    case direction
    when 1 then handler.move_forward(train_index)
    when 2 then handler.move_back(train_index)
    else raise 'Ошибка, выбрано некорректное направление'
    end
  rescue RuntimeError => e
    puts e.message
  end

  def view_stations
    handler.stations.each do |station|
      puts station
      if station.trains.size.zero?
        puts '- На станции нет поездов'
      else
        puts '- Поезда:'
        station.each_train do |train|
          puts "- #{train}"
          puts '-- Вагоны:'
          train.each_vagon do |vagon, i|
            puts "-- #{i}: #{vagon}"
          end
        end
      end
    end
  end

  def view_trains
    view_list(handler.trains)
  end

  def occupy_vagon_space
    puts 'Выберите поезд'
    view_list(handler.trains)
    train_index = gets.chomp.to_i

    raise 'Ошибка, выбран несуществующий поезд' unless train_exists?(train_index)

    puts 'Выберите вагон'
    view_list(handler.trains[train_index].vagons)
    vagon_index = gets.chomp.to_i

    raise 'Ошибка, выбран несуществующий вагон' unless vagon_exists?(train_index, vagon_index)

    selected_vagon = handler.trains[train_index].vagons[vagon_index]
    if selected_vagon.is_a? CargoVagon
      puts 'Введите объем'
      selected_vagon.occupy_volume(gets.to_f)
    else
      selected_vagon.occupy_volume
    end
  end

  def vagon_exists?(train_index, vagon_index)
    vagon_index >= 0 && handler.trains[train_index].vagons.size > vagon_index
  end

  def station_exists?(station)
    !handler.stations[station].nil?
  end

  def route_exists?(route)
    !handler.routes[route].nil?
  end

  def train_exists?(train)
    !handler.trains[train].nil?
  end

  def view_list(list)
    list.each.with_index { |item, i| puts "#{i}. #{item}" }
  end

  def incorrect_action
    raise 'Ошибка! Некорректная команда!'
  rescue RuntimeError => e
    puts e.message
  end

  def handle_action(action)
    case action
    when '1' then create_station
    when '2' then create_train
    when '3' then create_route
    when '4' then add_station_to_route
    when '5' then remove_station_from_route
    when '6' then set_route
    when '7' then add_vagon
    when '8' then remove_vagon
    when '9' then move_train
    when '10' then view_stations
    when '11' then view_trains
    when '12' then occupy_vagon_space
    when 'help' then actions_list
    when 'exit' then exit
    else incorrect_action
    end
  end

  def request_action
    loop do
      puts '----------------------'
      puts 'Введите код операции. help - список команд, exit - завершение программы'
      handle_action(gets.chomp)
    end
  end
end
