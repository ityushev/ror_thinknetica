require_relative 'instance_counter'
require_relative 'validate'

class Route
  include InstanceCounter
  include Validate

  attr_reader :stations

  def initialize(from, to)
    @stations = [from, to]
    validate!
    register_instance
  end

  def validate!
    raise 'Неверный тип начальной станции, ожидается Station' unless stations.all? {|station| station.is_a? Station }
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def remove_station(station_index)
    @stations.delete_at(station_index) if station_index > 0 && station_index < @stations.size - 1  
  end

  def show_stations
    puts @stations.map { |station| station.name }
  end
end
