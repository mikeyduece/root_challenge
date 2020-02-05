require './test/test_helper'
require './lib/driver'
require './lib/trip'

class TripTest < Minitest::Test
  attr_reader :trip_1, :trip_2

  def setup
    @trip_1 = Trip.new(start_at: '07:15', end_at: '07:45', distance: 17.3)
    @trip_2 = Trip.new(start_at: '08:00', end_at: '09:00', distance: 20.4)
  end

  def test_it_exists
    assert_instance_of(Trip, trip_1)
  end

  def test_it_has_a_start_time
    assert_instance_of(Time, trip_1.start_at)
  end

  def test_it_can_have_different_start_time
    refute_equal(trip_1.start_at, trip_2.start_at)
  end

  def test_it_has_an_end_time
    assert_instance_of(Time, trip_1.end_at)
  end

  def test_it_can_have_different_end_time
    refute_equal(trip_1.end_at, trip_2.end_at)
  end

  def test_it_has_a_distance
    distance = trip_1.distance

    assert_instance_of(Float, distance)
    assert_equal(17.3, distance)
  end

  def test_it_has_different_distance
    distance_1 = trip_1.distance
    distance_2 = trip_2.distance

    assert_equal(17.3, distance_1)
    
    refute_equal(distance_1, distance_2)
    assert_equal(20.4, distance_2)
  end

end