class CargoVagon < Vagon
  attr_accessor :total_volume
  attr_accessor :occupied_volume

  def initialize(total_volume)
    self.total_volume = total_volume
    validate!
    self.occupied_volume = 0
  end

  def occupy_volume(extra_volume)
    raise 'Весь объем занят' if total_volume == occupied_volume
    self.occupied_volume += extra_volume
  end

  def empty_volume
    total_volume - occupied_volume
  end

  def summary
    "Грузовой, свободный объем: #{empty_volume}, занятый объем: #{occupied_volume}"
  end

  private

  def validate!
    raise 'Некорректный объем' if total_volume < 0
  end
end
