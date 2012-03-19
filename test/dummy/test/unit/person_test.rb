require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  setup do
    # Give a default timezone to operate under if not explicitly set
    Time.zone = 'Central Time (US & Canada)'
  end

  # Class methods available
  test "class supports extensions" do
    assert Person.respond_to?(:locale_date)
    assert Person.respond_to?(:locale_datetime)
    assert Person.respond_to?(:locale_time)
  end

  #
  # Instance methods added
  #
  test "support default date accessor methods" do
    p = Person.new
    assert p.respond_to?(:born_on_as_text)
    assert p.respond_to?(:born_on_as_text=)
  end

  test "support default datetime accessor methods" do
    p = Person.new
    assert p.respond_to?(:last_seen_at_as_text)
    assert p.respond_to?(:last_seen_at_as_text=)
  end

  test "support default time accessor methods" do
    p = Person.new
    assert p.respond_to?(:start_time_as_text)
    assert p.respond_to?(:start_time_as_text=)
  end

  test "support custom ending accessor methods" do
    p = Person.new
    assert p.respond_to?(:born_on_ymd_text)
    assert p.respond_to?(:born_on_ymd_text=)
    #
    assert p.respond_to?(:last_seen_at_long_text)
    assert p.respond_to?(:last_seen_at_long_text=)
    #
    assert p.respond_to?(:start_time_short_text)
    assert p.respond_to?(:start_time_short_text=)
  end

  test "support custom named accessor methods" do
    p = Person.new
    assert p.respond_to?(:born_on_ymd_version)
    assert p.respond_to?(:born_on_ymd_version=)
    #
    assert p.respond_to?(:last_seen_long_version)
    assert p.respond_to?(:last_seen_long_version=)
    #
    assert p.respond_to?(:start_time_short_version)
    assert p.respond_to?(:start_time_short_version=)
  end

  test "support custom formatted accessor methods with default ending" do
    p = Person.new
    assert p.respond_to?(:born_on_as_ymd)
    assert p.respond_to?(:born_on_as_ymd=)
    #
    assert p.respond_to?(:last_seen_at_as_long)
    assert p.respond_to?(:last_seen_at_as_long=)
    #
    assert p.respond_to?(:start_time_as_short)
    assert p.respond_to?(:start_time_as_short=)
  end

  #
  # Default assignment and return using text
  #
  test "support returning default date as text" do
    p = Person.new(:born_on => Date.new(2000, 12, 30))
    assert_equal p.born_on_as_text, '12/30/2000'
  end

  test "support receiving default date as text" do
    p = Person.new
    p.born_on_as_text = '12/30/2000'
    assert_equal p.born_on, Date.new(2000, 12, 30)
  end

  test "support returning default datetime as text" do
    Time.zone = 'Central Time (US & Canada)'
    p = Person.new(:last_seen_at => DateTime.new(2012, 12, 30, 23, 30, 0).utc)
    assert_equal '12/30/2012 05:30pm', p.last_seen_at_as_text
  end

  test "support receiving default datetime as text" do
    p = Person.new
    p.last_seen_at_as_text = '12/30/2012'
    assert_equal Time.zone.local(2012, 12, 30, 0, 0, 0), p.last_seen_at
  end

  test "support returning default time as text" do
    p = Person.new(:start_time => Time.zone.local(2012, 12, 30, 23, 30, 0))
    assert_equal '12/30/2012 11:30pm', p.start_time_as_text
  end

  test "support receiving default time as text" do
    p = Person.new
    p.start_time_as_text = '12/30/2012 11:30pm'
    assert_equal Time.zone.local(2012, 12, 30, 23, 30, 0), p.start_time
  end

  test "support returning a nil value" do
    p = Person.new
    assert_equal nil, p.born_on_as_text
    assert_equal nil, p.start_time_as_text
    assert_equal nil, p.last_seen_at_as_text
  end

  test "support assigning a nil value" do
    p = Person.new(:born_on => Date.today, :start_time => Time.zone.now, :last_seen_at => DateTime.now)
    p.born_on_as_text = nil
    p.start_time_as_text = nil
    p.last_seen_at_as_text = nil
    assert_equal nil, p.born_on
    assert_equal nil, p.start_time
    assert_equal nil, p.last_seen_at
  end

  #
  # Custom Date behavior
  #
  test "support custom date suffix" do
    p = Person.new
    assert p.respond_to?(:born_on_ymd_text)
    assert p.respond_to?(:born_on_ymd_text=)
  end

  test "support returning custom date format" do
    p = Person.new(:born_on => Date.new(2000, 12, 30))
    assert_equal '2000-12-30', p.born_on_ymd_text
  end

  test "support receiving custom date format" do
    p = Person.new
    p.born_on_ymd_text = '2000-12-30'
    assert_equal p.born_on, Date.new(2000, 12, 30)
  end

  #
  # Custom DateTime behavior
  #
  test "support custom datetime suffix" do
    p = Person.new
    assert p.respond_to?(:last_seen_at_long_text)
    assert p.respond_to?(:last_seen_at_long_text=)
  end

  test "support returning custom datetime format" do
    p = Person.new(:last_seen_at => DateTime.new(2012, 12, 30, 23, 30, 0).utc)
    assert_equal '12/30/2012 05:30pm', p.last_seen_at_long_text
  end

  test "support receiving custom datetime format" do
    p = Person.new
    p.last_seen_at_long_text = '12/30/2012 11:30pm'
    assert_equal Time.zone.local(2012, 12, 30, 23, 30, 0), p.last_seen_at
  end

  #
  # Custom Time behavior
  #
  test "support custom time suffix" do
    p = Person.new
    assert p.respond_to?(:start_time_short_text)
    assert p.respond_to?(:start_time_short_text=)
  end

  test "support returning custom time format" do
    p = Person.new(:start_time => Time.zone.local(2012, 12, 30, 23, 30, 0))
    assert_equal '11:30pm', p.start_time_short_text
  end

  test "support receiving custom time format" do
    p = Person.new
    p.start_time_short_text = '11:30pm'
    today = Date.today
    result_time = Time.zone.local(today.year, today.month, today.day, 23, 30, 0)
    assert_equal p.start_time, result_time
  end

  #
  # TimeZone behavior - DateTime
  #
  test "DateTime respect timezone when retrieving value" do
    Time.zone = 'Central Time (US & Canada)'
    p = Person.new(:last_seen_at => DateTime.new(2012, 12, 30, 23, 30, 0).utc)
    assert_equal '12/30/2012 05:30pm', p.last_seen_at_long_text

    Time.zone = 'Mountain Time (US & Canada)'
    assert_equal '12/30/2012 04:30pm', p.last_seen_at_long_text
  end

  test "DateTime respect timezone when parsing value" do
    Time.zone = 'Central Time (US & Canada)'
    p = Person.new
    p.last_seen_at_long_text = '12/30/2012 03:30pm'
    assert_equal Time.zone.local(2012, 12, 30, 15, 30, 0), p.last_seen_at
    assert_equal DateTime.new(2012, 12, 30, 21, 30, 0), p.last_seen_at        # underlying UTC value

    Time.zone = 'Mountain Time (US & Canada)'
    p.last_seen_at_long_text = '12/30/2012 03:30pm'
    assert_equal Time.zone.local(2012, 12, 30, 15, 30, 0), p.last_seen_at
    assert_equal DateTime.new(2012, 12, 30, 22, 30, 0), p.last_seen_at        # underlying UTC value
  end

  #
  # TimeZone behavior - Date
  #
  test "Date not affected by timezone when retrieving value" do
    Time.zone = 'Central Time (US & Canada)'
    p = Person.new(:born_on => Date.new(2012, 12, 30))
    assert_equal '2012-12-30', p.born_on_ymd_text

    Time.zone = 'Mountain Time (US & Canada)'
    assert_equal '2012-12-30', p.born_on_ymd_text
  end

  test "Date not affected by timezone when parsing value" do
    Time.zone = 'Central Time (US & Canada)'
    p = Person.new
    p.born_on_ymd_text = '2012-12-30'
    assert_equal DateTime.new(2012, 12, 30), p.born_on        # underlying UTC value

    Time.zone = 'Mountain Time (US & Canada)'
    p.born_on_ymd_text = '2012-12-30'
    assert_equal DateTime.new(2012, 12, 30), p.born_on        # underlying UTC value
  end

  #
  # TimeZone behavior - Time
  #
  test "Time respects timezone when retrieving value" do
    Time.zone = 'Central Time (US & Canada)'
    p = Person.new(:start_time => Time.zone.local(2012, 12, 31, 19, 23, 0).to_time)
    assert_equal '07:23pm', p.start_time_short_text

    Time.zone = 'Mountain Time (US & Canada)'
    assert_equal '06:23pm', p.start_time_short_text
  end

  test "Time respects timezone when parsing value" do
    test_date = Date.today

    Time.zone = 'Central Time (US & Canada)'
    p = Person.new
    p.start_time_short_text = '4:25pm'
    assert_equal Time.zone.local(test_date.year, test_date.month, test_date.day, 16, 25, 0), p.start_time
    assert_equal DateTime.new(test_date.year, test_date.month, test_date.day, 21, 25, 0).to_time,
                 p.start_time.to_time        # underlying UTC value

    Time.zone = 'Mountain Time (US & Canada)'
    p.start_time_short_text = '4:25pm'
    assert_equal Time.zone.local(test_date.year, test_date.month, test_date.day, 16, 25, 0), p.start_time
    assert_equal DateTime.new(test_date.year, test_date.month, test_date.day, 22, 25, 0).to_time,
                 p.start_time.to_time        # underlying UTC value
  end

  #
  # Set multiple attributes on one line
  #
  test "multiple attributes set at once" do
    class MultipleDefaultAttributesSet
      include LocaleDating
      attr_accessor :some_date_1, :some_date_2
      locale_date :some_date_1, :some_date_2
    end
    i = MultipleDefaultAttributesSet.new
    assert i.respond_to?(:some_date_1_as_text)
    assert i.respond_to?(:some_date_1_as_text=)
    assert i.respond_to?(:some_date_2_as_text)
    assert i.respond_to?(:some_date_2_as_text=)
  end

  test "multiple attributes cannot use :name" do
    #TODO: Validate that an exception is raised. Raise exception for overwriting an existing method.
    assert_raise LocaleDating::MethodOverwriteError do
      class MultipleNamedAttributesSet
        include LocaleDating
        attr_accessor :some_datetime_1, :some_datetime_2
        locale_datetime :some_datetime_1, :some_datetime_2, :name => :some_explicit_function_name
      end
    end
  end

  #
  # Prevent unintentional method overwrites
  #
  test "exception when overwriting existing method" do
    assert_raise LocaleDating::MethodOverwriteError do
      class ExistingMethodFound
        include LocaleDating
        attr_accessor :some_time_1
        def name(); 'howdy' end
        locale_time :some_time_1, :name => :name
      end
    end
  end
end
