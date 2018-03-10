class CargoTrain < Train
  protected

  def proper_vagon?(vagon)
    vagon.is_a? CargoVagon
  end
end
