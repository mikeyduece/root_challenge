require './lib/driver'
require './lib/trip'

class ReportGenerator
  attr_reader :input, :drivers
  
  def initialize(input)
    @input = input
    @drivers = []
    generate_models
  end
  
  def generate_models
    create_drivers
    
    drivers.each { |driver| set_trips_for_driver(driver) }
  end
  
  def sorted_drivers
    drivers.sort_by { |driver| total_miles_for_driver(driver) }.reverse
  end
  
  def generate_report!
    sorted_drivers.map do |driver|
      miles = total_miles_for_driver(driver)
      avg_speed = avg_mph(driver)
      
      if avg_speed
        "#{driver.name}: #{miles} miles @ #{avg_speed}mph\n"
      else
        "#{driver.name}: 0 miles\n"
      end
    end
  end
  
  def find_drivers
    input.select { |i| i.start_with?('Driver') }
  end
  
  def find_trips
    input.select { |i| i.start_with?('Trip') }
  end
  
  def set_trips_for_driver(driver)
    driver_trips = select_driver_trips(driver.name)
    trip_info = isolate_trip_information(driver_trips, driver)
    
    create_trips_for_driver(driver, trip_info)
  end
  
  def create_trips_for_driver(driver, trip_info)
    trip_info.each do |trips|
      next if trips.empty?
      
      driver.trips << Trip.new(start_at: trips[0], end_at: trips[1], distance: trips[2])
    end
  end
  
  def isolate_trip_information(driver_trips, driver_obj)
    driver_trips.map { |trip| trip.gsub("Trip #{driver_obj.name}\s", '').split }
  end
  
  def select_driver_trips(driver_name)
    find_trips.select { |trip| trip.split[1].eql?(driver_name) }
  end
  
  def create_drivers
    driver_names = find_drivers.map { |d| d.gsub(/Driver\s/, '') }
    
    driver_names.each { |name| @drivers << Driver.new(name: name.chomp) }
  end
  
  def total_miles_for_driver(driver)
    driver.trips.inject(0) { |acc, trip| acc += trip.distance }.round
  end
  
  def avg_mph(driver)
    return if driver.trips.empty?
    
    time_total = total_time(driver.trips)# / 3600
    total_miles = total_miles_for_driver(driver)
    
    (total_miles / time_total).round
  end
  
  def total_time(trips)
    trips.inject(0) { |acc, trip| acc += (trip.end_at - trip.start_at) } / 3600
  end
end