class PassengerVagon < Vagon
  attr_accessor :total_places
  attr_accessor :occupied_places

  def initialize(total_places)
    self.total_places = total_places
    validate!
    self.occupied_places = 0
  end

  def occupy_place
    raise 'Все места заняты' if total_places == occupied_places
    self.occupied_places += 1
  end

  def empty_places
    total_places - occupied_places
  end

  def summary
    "Пассажирский, мест свободно: #{empty_places}, мест занято: #{occupied_places}"
  end

  private

  def validate!
    raise 'Количество мест - целое положительное число' unless valid_places?
  end

  def valid_places?
    (total_places.is_a? Integer) && total_places > 0
  end
end
