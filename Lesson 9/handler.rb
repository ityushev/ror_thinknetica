require_relative 'station'
require_relative 'train'
require_relative 'passenger_train'
require_relative 'cargo_train'
require_relative 'route'
require_relative 'vagon'
require_relative 'cargo_vagon'
require_relative 'passenger_vagon'

class Handler
  attr_reader :stations
  attr_reader :trains
  attr_reader :routes

  def initialize
    @stations = []
    @trains = []
    @routes = []
  end

  def create_station(name)
    stations << Station.new(name)
  end

  def create_train(train_number, train_type)
    trains << train_type.new(train_number)
  end

  def create_route(station_from, station_to)
    routes << Route.new(stations[station_from], stations[station_to])
  end

  def add_station_to_route(route_index, station_index)
    routes[route_index].add_station(stations[station_index])
  end

  def remove_station_from_route(route_index, station_index)
    routes[route_index].remove_station(station_index)
  end

  def set_route(route_index, train_index)
    trains[train_index].apply_route(routes[route_index])
  end

  def add_vagon(train_index, vagon)
    trains[train_index].add_vagon(vagon)
  end

  def remove_vagon(train_index)
    trains[train_index].remove_vagon
  end

  def move_forward(train_index)
    trains[train_index].move_forward
  end

  def move_back(train_index)
    trains[train_index].move_back
  end
end
