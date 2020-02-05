require './test/test_helper'
require './lib/driver'
require './lib/trip'
require './lib/report_generator'


class ReportGeneratorTest < Minitest::Test
  attr_reader :report_gen, :driver_1, :driver_2, :driver_3,
              :trip_1, :trip_2, :trip_3, :trip_4
  
  def setup
    @driver_1 = Driver.new(name: 'Test')
    @driver_2 = Driver.new(name: 'Test2')
    @driver_3 = Driver.new(name: 'Test3')
    @trip_1 = Trip.new(start_at: '07:15', end_at: '07:45', distance: 17.3)
    @trip_2 = Trip.new(start_at: '08:00', end_at: '09:00', distance: 50.4)
    @trip_3 = Trip.new(start_at: '08:00', end_at: '09:00', distance: 50.4)
    @trip_4 = Trip.new(start_at: '09:10', end_at: '09:30', distance: 10.4)
    input_file = %w[
                      Driver\ Test Driver\ Test2 Driver\ Test3 Trip\ Test\ 07:15\ 07:45\ 17.3
                      Trip\ Test\ 08:00\ 09:00\ 50.4 Trip\ Test2\ 08:00\ 09:00\ 50.4
                      Trip\ Test2\ 09:10\ 09:30\ 10.4
                    ]
    @report_gen = ReportGenerator.new(input_file)
  end
  
  def test_it_exists
    refute_empty(report_gen.drivers)
    assert_instance_of(ReportGenerator, report_gen)
  end

  def test_it_can_separate_drivers
    actual = report_gen.find_drivers
    refute(actual.include?('Trip'))
  end

  def test_it_can_separate_trips
    actual = report_gen.find_trips
    refute(actual.include?('Driver'))
  end
  
  def test_it_creates_drivers
    assert_instance_of(Driver, report_gen.drivers.first)
  end

  def test_it_create_trip_objects
    trips = report_gen.drivers.first.trips
    refute_empty(trips)
    assert_instance_of(Trip, trips.first)
  end

  def test_it_can_calculate_total_miles_per_driver
    driver_1.add_trip(trip_1)
    driver_1.add_trip(trip_2)
    actual = report_gen.total_miles_for_driver(driver_1)
    expected = 68
    
    assert_equal(expected, actual)
  end
  
  def test_it_can_calculate_different_total_milers_per_driver
    driver_1.add_trip(trip_1)
    driver_1.add_trip(trip_2)
    driver_2.add_trip(trip_3)
    driver_2.add_trip(trip_4)
    actual = report_gen.total_miles_for_driver(driver_2)
    expected = 61
    
    assert_equal(expected, actual)
  end

  def test_it_can_sort_drivers
    sorted = report_gen.sorted_drivers
    first_sorted = report_gen.total_miles_for_driver(sorted.first)
    last_sorted = report_gen.total_miles_for_driver(sorted.last)
  
    assert(first_sorted > last_sorted)
  end

  def test_it_can_total_time_spent_for_drivers_trips
    driver_1.add_trip(trip_1)
    driver_1.add_trip(trip_2)
    actual = report_gen.total_time(driver_1.trips)
    expected = 1.5
    
    assert_equal(expected, actual)
  end

  def test_it_can_total_time_for_different_drivers_trips
    driver_1.add_trip(trip_1)
    driver_1.add_trip(trip_2)
    driver_2.add_trip(trip_3)
    driver_2.add_trip(trip_4)
    actual = report_gen.total_time(driver_2.trips)
    expected = 1.3333333333333333
  
    assert_equal(expected, actual)
  end

  def test_it_can_calcualte_average_speed_per_driver
    driver_1.add_trip(trip_1)
    driver_1.add_trip(trip_2)
    actual = report_gen.avg_mph(driver_1)
    expected = 45
    
    assert_equal(expected, actual)
  end
  
  def test_it_can_calculate_avg_speed_for_different_driver
    driver_2.add_trip(trip_3)
    driver_2.add_trip(trip_4)
    actual = report_gen.avg_mph(driver_2)
    expected = 46
    
    assert_equal(expected, actual)
  end
  
  def test_it_can_generate_report
    actual = report_gen.generate_report!
    expected = "Test: 68 miles @ 45mph\n"
    
    assert_equal(expected, actual[0])
  end
  
  def test_it_can_generate_report_for_driver_with_no_trips
    actual = report_gen.generate_report!
    expected = "Test3: 0 miles\n"
    
    assert_equal(expected, actual[2])
  end
  
  private
  
  def grouped_trips_1
    [trip_1, trip_2]
  end
  
  def grouped_trips_2
    [trip_3, trip_4]
  end

end