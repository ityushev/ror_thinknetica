class PassengerTrain < Train
  protected

  def proper_vagon?(vagon)
    vagon.is_a? PassengerVagon
  end
end
