require './test/test_helper'
require './lib/driver'
require './lib/trip'

class DriverTest < Minitest::Test
  attr_reader :driver, :trip_1, :trip_2

  def setup
    @driver = Driver.new(name: 'Test')
    @trip_1 = Trip.new(start_at: '07:15', end_at: '07:45', distance: 17.3)
    @trip_2 = Trip.new(start_at: '08:00', end_at: '09:00', distance: 20.4)
  end

  def test_it_exists
    assert_instance_of(Driver, driver)
  end

  def test_it_has_a_name
    driver_name = driver.name
    assert_equal('Test', driver_name)
  end

  def test_it_can_have_a_different_name
    driver_2 = Driver.new(name: 'Test2')

    refute_equal(driver.name, driver_2.name)
    assert_equal('Test2', driver_2.name)
  end

  def test_it_starts_with_empty_trips
    assert_instance_of(Array, driver.trips)
    assert_empty(driver.trips)
  end

  def test_it_can_add_trip_for_driver
    assert_equal(0, driver.trips.count)
    assert_empty(driver.trips)
    
    driver.add_trip(trip_1)
    actual = driver.trips

    assert_instance_of(Trip, actual[0])
    assert_equal(1, actual.length)
    assert_equal('07:15', actual[0].start_at.strftime('%H:%M'))
    refute_equal('08:00', actual[0].start_at.strftime('%H:%M'))
  end

  def test_test_it_can_add_more_than_one_trip
    assert_equal(0, driver.trips.count)
    assert_empty(driver.trips)
    
    driver.add_trip(trip_1)
    
    assert_equal(1, driver.trips.count)
    refute_empty(driver.trips)
    
    driver.add_trip(trip_2)
    actual = driver.trips

    assert_equal(2, actual.count)
    assert_equal('07:15', actual[0].start_at.strftime('%H:%M'))
    assert_equal('08:00', actual[1].start_at.strftime('%H:%M'))
    refute_equal(actual[0].start_at, actual[1].start_at)
  end

  def test_it_has_different_trips_for_different_drivers
    driver2 = Driver.new(name: 'Testing2')
    driver.add_trip(trip_1)
    driver2.add_trip(trip_2)
    
    refute_equal(driver.trips[0], driver2.trips[0])
  end

  def test_it_has_same_trip_info_for_different_drivers
    driver2 = Driver.new(name: 'Testing2')
    driver.add_trip(trip_1)
    driver2.add_trip(trip_1)
  
    assert_equal(driver.trips[0], driver2.trips[0])
  end

end