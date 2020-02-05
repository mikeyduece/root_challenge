class Driver
  attr_reader :name, :trips

  def initialize(name:)
    @name = name
    @trips = []
  end

  def add_trip(trip)
    @trips << trip
  end

end