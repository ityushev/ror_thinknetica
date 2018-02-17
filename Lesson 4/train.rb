class Train
  attr_reader :speed
  attr_reader :vagons
  attr_reader :route
  attr_reader :number

  def initialize(number)
    @number = number
    @vagons = []
    @speed = 0
  end

  def speed_up(additional_speed)
    self.speed =+ additional_speed
  end

  def stop
    self.speed = 0
  end

  def add_vagon(vagon)
    vagons << vagon if proper_vagon?(vagon) && speed == 0
  end

  def remove_vagon
    self.vagons.delete_at(-1) if speed == 0
  end

  def set_route(route)
    self.route = route
    self.station_index = 0
    current_station.receive_train(self)
  end

  def move_forward
    unless next_station.nil?
      current_station.send_train(self)
      next_station.receive_train(self)
      self.station_index += 1 
    end
  end

  def move_back
    unless previous_station.nil?
      current_station.send_train(self)
      previous_station.receive_train(self)
      self.station_index -= 1
    end
  end

  protected

  attr_writer :speed
  attr_writer :vagons
  attr_writer :route
  attr_accessor :station_index

  # эти методы используются как вспомогательные публичными методами
  # мы даем доступ к публичным методам, которые выдают конечный результат, нужный пользователю,
  # в то время как методы ниже производят промежуточные вычисления
  def previous_station
    route.stations[station_index - 1] if station_index > 0
  end

  def next_station
    route.stations[station_index + 1] if route.stations.size > station_index + 1
  end

  def current_station
    route.stations[station_index]
  end

  def proper_vagon?(vagon)
    vagon.is_a? Vagon
  end
end
