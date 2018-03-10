class PassengerVagon < Vagon
  def occupy_volume
    raise 'Все места заняты' if total_volume <= occupied_volume
    self.occupied_volume += 1
  rescue RuntimeError => e
    puts e.message
  end
end
