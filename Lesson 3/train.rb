class Train
  attr_reader :speed
  attr_reader :vagon_quantity
  attr_reader :type

  def initialize(number, type, vagon_quantity)
    @number = number
    @type = type
    @vagon_quantity = vagon_quantity
    @speed = 0
  end

  def speed_up(additional_speed)
    @speed =+ additional_speed
  end

  def stop
    @speed = 0
  end

  def add_vagon
    @vagon_quantity += 1 if @speed == 0  
  end

  def remove_vagon
    @vagon_quantity -= 1 if @speed == 0 && @vagon_quantity > 0
  end

  def set_route(route)
    @route = route
    @station_index = 0
    current_station.receive_train(self)
  end

  def move_forward
    unless next_station.nil?
      current_station.send_train(self)
      next_station.receive_train(self)
      @station_index += 1 
    end
  end

  def move_back
    unless previous_station.nil?
      current_station.send_train(self)
      previous_station.receive_train(self)
      @station_index -= 1
    end
  end

  def previous_station
    @route.stations[@station_index - 1] if @station_index > 0
  end

  def next_station
    @route.stations[@station_index + 1] if @route.stations.size > @station_index + 1
  end

  def current_station
    @route.stations[@station_index]
  end
end
