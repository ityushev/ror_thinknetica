class PassengerTrain < Train
  validate :number, :presence
  validate :number, :format, NUMBER_FORMAT
  
  protected

  def proper_vagon?(vagon)
    vagon.is_a? PassengerVagon
  end
end
