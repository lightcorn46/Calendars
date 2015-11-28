# Copyright (c) 2015 Daniel August
# MIT License
# Version 1.0.0

# This code prints a calendar for a given year and month in an array form:
#
#               ## OCTOBER 2015
#
#               |  MO  |  TU  |  WE  |  TH  |  FR  |
#               |------|------|------|------|------|
#               |      |      |**01**|**02**|**03**|
#               ||||||
#               |**05**|**06**|**07**|**08**|**09**|
#               ||||||
#               |**12**|**13**|**14**|**15**|**16**|
#               ||||||
#               |**19**|**20**|**21**|**22**|**23**|
#               ||||||
#               |**26**|**27**|**28**|**29**|**30**|
#               ||||||

# Or a list form:
#
#              |------------------ JANUARY 2016 ------------------|
#
#               01 FR
#               02 SA
#               03 SU
#
#               04 MO
#               05 TU
#               06 WE
#               07 TH
#               08 FR
#               09 SA
#               10 SU

# For rendering by phpmarkdownextra as an extension of mkdocs



def monthMax year, month        # Returns the maximum date for a given year and month
  case month
  when 1
    31
  when 2
      if year.modulo(4) == 0
        29
      else
        28
      end
  when 3
    31
  when 4
    30
  when 5
    31
  when 6
    30
  when 7
    31
  when 8
    31
  when 9
    30
  when 10
    31
  when 11
    30
  when 12
    31
  end
end

def monthName month                   # Returns the name of a given month
  case month
  when 1
    "JANUARY"
  when 2
    "FEBRUARY"
  when 3
    "MARCH"
  when 4
    "APRIL"
  when 5
    "MAY"
  when 6
    "JUNE"
  when 7
    "JULY"
  when 8
    "AUGUST"
  when 9
    "SEPTEMBER"
  when 10
    "OCTOBER"
  when 11
    "NOVEMBER"
  when 12
    "DECEMBER"
  end
end

def dayName weekness
  case weekness
  when 1
    "MO"
  when 2
    "TU"
  when 3
    "WE"
  when 4
    "TH"
  when 5
    "FR"
  end
end

def stringDayA date, i                  # Returns a date formatted for array calendar

  weekness = i.modulo(7)

  if weekness == 0
    s = "|"                                   # "weekness" refers to the numerical value
  elsif weekness == 6                         # of the day of the week modulo 7:
    s = ""                                    # The weekness of Sunday is 0
  else                                        # The weekness of Monday is 1
    if date == nil                            # etc
      s = "      |"
    elsif date.to_i < 10
      s = "**0#{date}**|"
    else
      s = "**#{date}**|"
    end
  end
  return(s)
end

def stringDayL date, weekness                  # Returns a date formatted for list calendar
                                        # "weekness" refers to the numerical value
  if date.to_i < 10                         # of the day of the week modulo 7:
    s = "0#{date}  #{dayName weekness}"     # The weekness of Sunday is 0
  else                                      # The weekness of Monday is 1
    s = "#{date}  #{dayName weekness}"      # etc
  end

  return(s)
end

def startMonth year, month                       # Returns weekness for the 1st day
                                                  # of a given month in the 2000s
  y = year - 2000                                  # calcuated using Doomsday Algorithm
  doom = ((y / 12).floor + y.modulo(12) + (y.modulo(12) / 4).floor).modulo(7) + 2

  case month
  when 1
    if year.modulo(4) == 0
      (doom - 3).modulo(7)
    else
      (doom - 2).modulo(7)
    end
  when 2
    if year.modulo(4) == 0
      (doom - 28).modulo(7)
    else
      (doom - 27).modulo(7)
    end
  when 3
    (doom + 1).modulo(7)
  when 4
    (doom - 3).modulo(7)
  when 5
    (doom - 8).modulo(7)
  when 6
    (doom - 5).modulo(7)
  when 7
    (doom - 10).modulo(7)
  when 8
    (doom - 7).modulo(7)
  when 9
    (doom - 4).modulo(7)
  when 10
    (doom - 9).modulo(7)
  when 11
    (doom - 6).modulo(7)
  when 12
    (doom - 11).modulo(7)
  end

end

def alignCal year, month                     # Populates and returns an array
                                              # with dates lined up with the
  dateArray = []                              # weekness of the 1st of the month.
  date = 1                                    # Ex: if the 2nd day is a Thursday,
  i = (startMonth year, month)                # then dateArray[4] == 2.
  max = (monthMax year, month)

  while date <= max
    dateArray[i] = date
    i += 1
    date += 1
  end

  return(dateArray)
end

def stringCalA year, month                       # Converts dates into printable text

  dateArray = (alignCal year, month)
  stringArray = []
  i = 0
  dateArray.each do |d|
    stringArray[i] = (stringDayA d, i)
    i += 1
  end

  if i.modulo(7) == 1
    stringArray[i-1] = nil                      # Deletes extra pipe if month ends on Sun
  else
    while i.modulo(7) != 6 && i.modulo(7) != 0     # Finishes out the last week with pipes
      stringArray[i] = "|"
      i += 1
    end
  end

  return(stringArray)

end

def stringCalL year, month

  date = 1
  weekness = (startMonth year, month)
  max = monthMax year, month

  puts

  while date <= max
    if weekness == 6
    elsif weekness == 0 && (date >= 3 && date < max)
      puts
    elsif weekness == 0
    else
      puts stringDayL date, weekness
    end

    date += 1
    weekness = (weekness + 1).modulo(7)

  end

end

def printCal year, month, type     # Prints calendar for given year, month, as array or list

  if type.upcase == "ARRAY"           # Array Calendar

    stringArray = (stringCalA year, month)

    puts "\#\# #{monthName month} #{year}"            # Prints header for calendar
    puts
    puts "|  MO  |  TU  |  WE  |  TH  |  FR  |"
    puts "|------|------|------|------|------|"

    while stringArray[0] != nil                     # Prints out a week at a time
      puts (stringArray.shift(7)).join
      puts "||||||"
    end

  else                                  # List Calendar

    puts "|------------------ #{monthName month} #{year} ------------------|"
    stringCalL year, month
    puts

  end

end


# ---------------------------   MAIN   ------------------------------- #

puts "What year?"
year = gets.to_i
puts
puts
puts "What month?"
month = gets.to_i
puts
puts
puts "Do you want an array or list?"
type = gets.chomp
puts
puts

if month != 0                         # Prints a single month
  printCal year, month, type
else                                  # Prints a whole school year
  month = 9                           # Sept - Dec
  while month <= 12
    printCal year, month, type
    puts
    month += 1
  end

  month = 1                           # Happy New Year!!
  year += 1

  while month <= 6                    # Prints Jan - June
    printCal year, month, type
    puts
    month += 1
  end
end
