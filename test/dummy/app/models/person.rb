class Person < ActiveRecord::Base
  locale_date :born_on
  locale_datetime :last_seen_at
  locale_time :start_time

  # Custom formats default endings
  locale_date :born_on, :format => :ymd
  locale_datetime :last_seen_at, :format => :long
  locale_time :start_time, :format => :short

  # Custom endings
  locale_date :born_on, :format => :ymd, :ending => :ymd_text
  locale_datetime :last_seen_at, :format => :long, :ending => :long_text
  locale_time :start_time, :format => :short, :ending => :short_text

  # Explicit names given
  locale_date :born_on, :format => :ymd, :name => :born_on_ymd_version
  locale_datetime :last_seen_at, :format => :long, :name => :last_seen_long_version
  locale_time :start_time, :format => :short, :name => :start_time_short_version

end
