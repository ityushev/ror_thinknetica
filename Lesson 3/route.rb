class Route
  attr_reader :stations

  def initialize(from, to)
    @stations = [from, to]
  end

  def add_station(station)
    @stations.insert(-2, station)
  end

  def remove_station(station)
    @stations.delete(station) if @stations.index(station) > 0 && @stations.index(station) < @stations.size - 1  
  end

  def show_stations
    @stations.each { |station| puts station.name }
  end
end
