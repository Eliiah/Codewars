=begin
Your task in order to complete this Kata is to write a function which formats a duration, given as a number of seconds, in a human-friendly way.

The function must accept a non-negative integer. If it is zero, it just returns "now". Otherwise, the duration is expressed as a combination of years, days, hours, minutes and seconds.

It is much easier to understand with an example:

* For seconds = 62, your function should return 
    "1 minute and 2 seconds"
* For seconds = 3662, your function should return
    "1 hour, 1 minute and 2 seconds"

For the purpose of this Kata, a year is 365 days and a day is 24 hours.

Note that spaces are important.
Detailed rules

The resulting expression is made of components like 4 seconds, 1 year, etc. In general, a positive integer and one of the valid units of time, separated by a space. The unit of time is used in plural if the integer is greater than 1.

The components are separated by a comma and a space (", "). Except the last component, which is separated by " and ", just like it would be written in English.

A more significant units of time will occur before than a least significant one. Therefore, 1 second and 1 year is not correct, but 1 year and 1 second is.

Different components have different unit of times. So there is not repeated units like in 5 seconds and 1 second.

A component will not appear at all if its value happens to be zero. Hence, 1 minute and 0 seconds is not valid, but it should be just 1 minute.

A unit of time must be used "as much as possible". It means that the function should not return 61 seconds, but 1 minute and 1 second instead. Formally, the duration specified by of a component must not be greater than any valid more significant unit of time.
=end

def format_duration(seconds)
    return 'now' if seconds.zero?
    year, reminder = seconds.divmod(31536000)
    day, reminder = reminder.divmod(86400)
    hour, reminder = reminder.divmod(3600)
    minute, seconds = reminder.divmod(60)
    year_text = text_for_numb(year, 'year')
    day_text = text_for_numb(day, 'day')
    hour_text = text_for_numb(hour, 'hour')
    minute_text = text_for_numb(minute, 'minute')
    second_text = text_for_numb(seconds, 'second')
    together = [year_text, day_text, hour_text, minute_text, second_text].compact
    last = together.pop
    return last if together.empty?
    together.join(', ') + " and #{last}"
  end
  
  def text_for_numb(number, base_text)
    return if number.zero?
    "#{number} #{base_text}#{'s' if number > 1}"
  end