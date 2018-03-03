require_relative 'manufacturer'

class Vagon
  include Manufacturer

  attr_accessor :total_volume
  attr_accessor :occupied_volume

  def initialize(total_volume)
    self.total_volume = total_volume
    validate!
    self.occupied_volume = 0
  end

  def validate!
    raise 'Некорректный объем или количество мест' if (total_volume.nil? || total_volume < 0) 
  end

  def to_s
    "#{self.class}, свободно: #{empty_volume}, занято: #{occupied_volume}"
  end

  def empty_volume
    total_volume - occupied_volume
  end

end
