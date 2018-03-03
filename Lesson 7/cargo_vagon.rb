class CargoVagon < Vagon
  def occupy_volume(extra_volume)
    raise 'Недостаточно места' if total_volume < occupied_volume + extra_volume
    self.occupied_volume += extra_volume
  rescue RuntimeError => e
    puts e.message
  end
end
