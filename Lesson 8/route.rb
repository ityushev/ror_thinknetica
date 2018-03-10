require_relative 'instance_counter'
require_relative 'validate'

class Route
  include InstanceCounter
  include Validate

  attr_reader :stations

  MESSAGES = {
    type: 'Неверный тип начальной станции, ожидается Station'
  }.freeze

  def initialize(station_from, station_to)
    @stations = [station_from, station_to]
    validate!
    register_instance
  end

  def validate!
    raise MESSAGES[:type] unless stations_valid?
  end

  def stations_valid?
    stations.all? { |station| station.is_a? Station }
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def remove_station(station_index)
    @stations.delete_at(station_index) if station_removable?(station_index)
  end

  def station_removable?(station_index)
    station_index > 0 && station_index < @stations.size && @stations.size > 2
  end

  def show_stations
    puts @stations.map(&:name)
  end

  def to_s
    "#{stations[0]} - #{stations[-1]}"
  end
end
