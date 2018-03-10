require_relative 'manufacturer'
require_relative 'instance_counter'
require_relative 'validate'

class Train
  include Manufacturer
  include InstanceCounter
  include Validate

  NUMBER_FORMAT = /^[a-z\d]{3}-?[a-z\d]{2}$/i

  attr_reader :speed
  attr_reader :vagons
  attr_reader :route
  attr_reader :number

  @@trains = {}

  def self.find(number)
    @@trains[number]
  end

  def initialize(number)
    @number = number
    validate!
    @vagons = []
    @speed = 0
    @@trains[number] = self
    register_instance
  end

  def each_vagon
    vagons.each.with_index(1) { |vagon, i| yield(vagon, i) }
  end

  def speed_up(additional_speed)
    @speed = + additional_speed
  end

  def stop
    @speed = 0
  end

  def add_vagon(vagon)
    vagons << vagon if proper_vagon?(vagon) && speed.zero?
  end

  def remove_vagon
    vagons.delete_at(-1) if speed.zero?
  end

  def apply_route(route)
    @route = route
    @station_index = 0
    current_station.receive_train(self)
  end

  def move_forward
    return if next_station.nil?

    current_station.send_train(self)
    next_station.receive_train(self)
    @station_index += 1
  end

  def move_back
    return if previous_station.nil?

    current_station.send_train(self)
    previous_station.receive_train(self)
    @station_index -= 1
  end

  def to_s
    "#{number} | тип: #{self.class} | Вагонов: #{vagons.size}"
  end

  protected

  def validate!
    raise 'Введите коорректный номер поезда' if number !~ NUMBER_FORMAT
  end

  def previous_station
    route.stations[@station_index - 1] if @station_index > 0
  end

  def next_station
    route.stations[@station_index + 1] if next_station_exists?
  end

  def next_station_exists?
    route.stations.size > @station_index + 1
  end

  def current_station
    route.stations[@station_index]
  end

  def proper_vagon?(vagon)
    vagon.is_a? Vagon
  end
end
