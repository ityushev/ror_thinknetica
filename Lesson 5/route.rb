class Route
  attr_reader :stations

  def initialize(from, to)
    @stations = [from, to]
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
