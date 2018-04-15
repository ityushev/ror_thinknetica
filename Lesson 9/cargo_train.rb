class CargoTrain < Train
  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT

  protected

  def proper_vagon?(vagon)
    vagon.is_a? CargoVagon
  end
end
