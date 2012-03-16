module LocaleDating
  # Respond to being included and extend the object with class methods.
  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    # Define how to split out a single date_time column/attribute into two attributes that can set the date and
    # time portions independently. Can be called multiple times per
    #
    # ==== Arguments
    # Accepts a list of attribute names that access date related model data.
    # * <tt>options</tt> - Options for overriding configuration.
    #
    # ==== Options
    # * <tt>:format</tt> - The desired date format name from the locale file to use for displaying and parsing
    #                      the value as text.
    # * <tt>:ending</tt> - The ending used on the wrapping methods for accessing and assigning the value.
    #                      Defaults to :as_text
    # * <tt>:name</tt> - The explicit wrapper method name to use for reading and writing the value as text.
    #                    Overrides and :ending option.
    #
    # ==== Example
    # Standard usage accepting defaults.
    #     locale_date :starts_on
    #     # creates methods "starts_on_as_text" and "starts_on_as_text=".
    #
    # Specify a different format from the locale file and a different suffix.
    #     locale_date :starts_on, :format => :special, :ending => :text
    #     # creates methods "starts_on_text" and "starts_on_text=". The :special format will be used
    #     # for display and parsing.
    #
    def locale_date(*args)
      options = args.extract_options!
      locale_dating_naming_option_defaults(options)

      # Loop through all the given attributes that should be wrapped using the same settings.
      args.each do |attrib|
        getter_name = options[:name].try(:to_sym)
        getter_name ||= "#{attrib}_#{options[:ending]}".to_sym
        setter_name = "#{getter_name}=".to_sym
        # Define the code to execute when the method is called
        # Create new methods for get and set calls with blocks for implementation.
        class_eval do
          # == Create the GET methods
          # EX: def date_of_birth_text()
          define_method getter_name do
            value = self.send(attrib)
            I18n.l(value, :format => options[:format]) if value
          end
          # == Create the SET methods
          # EX: def date_of_birth_text=()
          define_method setter_name do |value|
            date_value = nil
            date_value = DateTime.strptime(value.to_s, I18n.t("date.formats.#{options[:format]}")) unless value.blank?
            # Keep the date from the given value and preserve the original time part
            self.send("#{attrib}=", date_value)
          end
        end
      end

      #include InstanceMethods
    end

    # Define how to split out a single date_time column/attribute into two attributes that can set the date and
    # time portions independently. Can be called multiple times per
    #
    # ==== Arguments
    # Accepts a list of attribute names that access date related model data.
    # * <tt>options</tt> - Options for overriding configuration.
    #
    # ==== Options
    # * <tt>:format</tt> - The desired time format name from the locale file to use for displaying and parsing
    #                      the value as text.
    # * <tt>:ending</tt> - The suffix used on the wrapping methods for accessing and assigning the value.
    # * <tt>:name</tt> - The explicit wrapper method name to use for reading and writing the value as text.
    #                    Overrides and :ending option.
    #
    # ==== Example
    # Standard usage accepting defaults.
    #     date_time_split :starts_at
    #     # creates methods "starts_at_date" and "starts_at_time" that both write to the "starts_at" column.
    #
    # Override default method maps to custom ones.
    #     date_time_split :starts_at, :date => :date_starts_at, :time_starts_at
    #     # creates methods "date_starts_at" and "time_starts_at" that both write to the "starts_at" column.
    #
    def locale_time(*args)
      options = args.extract_options!
      locale_dating_naming_option_defaults(options)

      # Loop through all the given attributes that should be wrapped using the same settings.
      args.each do |attrib|
        getter_name = options[:name].try(:to_sym)
        getter_name ||= "#{attrib}_#{options[:ending]}".to_sym
        setter_name = "#{getter_name}=".to_sym
        # Define the code to execute when the method is called
        # Create new methods for get and set calls with blocks for implementation.
        class_eval do
          # == Create the GET methods
          # EX: def date_of_birth_text()
          define_method getter_name do
            value = self.send(attrib)
            I18n.l(value.in_time_zone, :format => options[:format]) if value
          end
          # == Create the SET methods
          # EX: def date_of_birth_text=()
          define_method setter_name do |value|
            time_value = nil
            if !value.blank?
              time_value = DateTime.strptime(value.to_s, I18n.t("time.formats.#{options[:format]}"))
              time_value = Time.zone.local(time_value.year, time_value.month, time_value.day,
                                           time_value.hour, time_value.min, time_value.sec)
            end
            # Keep the date from the given value and preserve the original time part
            self.send("#{attrib}=", time_value)
          end
        end
      end

      #include InstanceMethods
    end

    # Define how to split out a single date_time column/attribute into two attributes that can set the date and
    # time portions independently. Can be called multiple times per
    #
    # ==== Arguments
    # Accepts a list of attribute names that access date related model data.
    # * <tt>options</tt> - Options for overriding configuration.
    #
    # ==== Options
    # * <tt>:format</tt> - The desired datetime format name from the locale file to use for displaying and parsing
    #                      the value as text.
    # * <tt>:ending</tt> - The suffix used on the wrapping methods for accessing and assigning the value.
    # * <tt>:name</tt> - The explicit wrapper method name to use for reading and writing the value as text.
    #                    Overrides and :ending option.
    #
    # ==== Example
    # Standard usage accepting defaults.
    #     date_time_split :starts_at
    #     # creates methods "starts_at_date" and "starts_at_time" that both write to the "starts_at" column.
    #
    # Override default method maps to custom ones.
    #     date_time_split :starts_at, :date => :date_starts_at, :time_starts_at
    #     # creates methods "date_starts_at" and "time_starts_at" that both write to the "starts_at" column.
    #
    def locale_datetime(*args)
      options = args.extract_options!
      locale_dating_naming_option_defaults(options)

      # Loop through all the given attributes that should be wrapped using the same settings.
      args.each do |attrib|
        getter_name = options[:name].try(:to_sym)
        getter_name ||= "#{attrib}_#{options[:ending]}".to_sym
        setter_name = "#{getter_name}=".to_sym
        # Define the code to execute when the method is called
        # Create new methods for get and set calls with blocks for implementation.
        class_eval do
          # == Create the GET methods
          # EX: def date_of_birth_text()
          define_method getter_name do
            value = self.send(attrib)
            I18n.l(value.in_time_zone, :format => options[:format]) if value
          end
          # == Create the SET methods
          # EX: def date_of_birth_text=()
          define_method setter_name do |value|
            date_value = nil
            if !value.blank?
              date_value = DateTime.strptime(value.to_s, I18n.t("datetime.formats.#{options[:format]}"))
              date_value = Time.zone.local(date_value.year, date_value.month, date_value.day,
                                           date_value.hour, date_value.min, date_value.sec)
            end
            # Keep the date from the given value and preserve the original time part
            self.send("#{attrib}=", date_value)
          end
        end
      end

    end


    private
    # Given the options for a locale_dating call, set the defaults for the naming convention to use.
    def locale_dating_naming_option_defaults(options)
      options.reverse_merge!(:format => :default)
      options[:ending] ||= "as_#{options[:format]}".to_sym unless options[:format] == :default
      options[:ending] ||= :as_text
    end
  end
end

# Include on ActiveRecord::Base.
ActiveRecord::Base.send :include, LocaleDating