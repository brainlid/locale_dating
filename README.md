# LocaleDating

LocaleDating does what Rails should be doing. It makes working with dates and times as text in forms painless.
It works with your I18n locales to use your desired formats and respects the user's timezone.

LocaleDating generates wrapper methods around the attributes you want to support editing
Date, Time, and DateTime values as text using any desired I18n locale format.

## Reason for Existence

This simple library was born out of the frustration experienced when using Rails 3.2.x and Ruby 1.9.2. Ruby
changed the default date parsing format from mm/dd/yyyy to dd/mm/yyyy. When letting a user edit a date or a time
on a form as text, Rails could no longer correctly parse a US date by default.

Common solutions seem to result in:

* explicitly converting the date to text and assigning to the form input
* parsing the form's param in the controller action and assigning to the model

While solving this problem, we get some other nice benefits. More on that after the examples.

## How it Works

Use the defined I18n locale formats from your application.

```yaml
# /config/locales/en.yml
en:
  date:
    formats:
      default: '%m/%d/%Y'
      short: '%m/%d/%Y'
      long: ! '%Y-%m-%d'
      ymd: ! '%Y-%m-%d'
  datetime:
    formats:
      default: '%m/%d/%Y'
      short: '%m/%d/%Y'
      long: ! '%m/%d/%Y %I:%M%p'
  time:
    am: am
    formats:
      default: ! '%m/%d/%Y %I:%M%p'
      short: ! '%I:%M%p'
      long: ! '%m/%d/%Y %I:%M%p'
    pm: pm
```

Specify which model attributes should be

```ruby
# /app/models/person.rb
class Person < ActiveRecord::Base
  locale_date :born_on
  locale_datetime :last_seen_at
  locale_time :start_time
end
```

## Behavior and Benefits

LocaleDating doesn't override the model's attribute. So you can still access the native data type directly as needed.

```ruby
p = Person.new
p.born_on = Date.new(2010, 10, 4)
```

LocaleDating creates wrapper methods for accessing the underlying value as text through your desired locale format.
It uses locale's 'default' format if no format is specified.

Because the attribute isn't overridden, you can specify multiple supported formats for a single attribute.

```ruby
# /app/models/person.rb
class Person < ActiveRecord::Base
  locale_datetime :last_seen_at
  locale_datetime :last_seen_at, :format => :long
  locale_datetime :last_seen_at, :format => :short, :ending => :shortened
  locale_datetime :last_seen_at, :format => :special, :name => :last_seen_so_special
end
```

Generated wrapper methods:

* when using the default format on :last_seen_at, it will be 'last_seen_at_as_text'
* when using the format :long on :last_seen_at, it will be 'last_seen_at_as_long'
* when specifying the ending 'shortened', it will be 'last_seen_at_shortened'
* when specifying the name 'last_seen_so_special', it uses it and will be 'last_seen_so_special'

In a view, you specify which version you want used by referencing the name like this:

```erb
<%= form_for @person do %>
  <%= f.label :born_on_as_text, 'Born On' %>:
  <%= f.text_field :born_on_as_text %><br />
<% end %>
```

The input's value is the :born_on value converted to text using the locale specified format. The controller receives
the user's modified text and passes it to the wrapper method. The wrapper method parses the text using the format
specified for the locale and respecting the user's timezone.

Its that easy! LocaleDating gives a super simple approach to only add the behavior to the attributes you want
while being customizable enough to work for your unique situations.

