require 'time'

class Trip
  attr_reader :start_at, :end_at, :distance

  def initialize(params)
    @start_at = Time.parse(params[:start_at])
    @end_at = Time.parse(params[:end_at])
    @distance = params[:distance].to_f
  end

end