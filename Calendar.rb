# Copyright (c) 2015 Daniel August
# MIT License

# This code prints a calendar for a given year and month in the form:
#
#               ================== 2016 ===================
#
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
#
# For a particular month enter the numeric month (1 Jan, 2 Feb, etc).
# To print an entire year, enter the month as 0.
#
# Code also included to add important annual events (birthdays, anniversaries, etc).

# For rendering by phpmarkdownextra as an extension of mkdocs


$calendarFile = "calendarFile.txt"
$importantDates = "importantDates.txt"

# ------------------------   iDATE CLASS   --------------------------- #
#
class Idate                               # Important Dates reside at a number
                                              # n = ((31 * (month - 1)) + date)*10000 + year
    def initialize address, event             # Ex: 982013 is 5 April 2013
      @address = address.to_i                  # The event is a description of the event
      @event = " #{event.to_s} [#{self.year}]"             # Ex: "Dash's banana bread day"
    end

    def address
      @address
    end

    def shortAddress
      (@address / 10000).floor
    end

    def event
      @event
    end

    def year                                      # Returns the year of the iDate
      @address.modulo(10000)
    end

    def month                                    # Returns the month of the iDate
      ((@address / 10000).floor / 31) + 1
    end

    def date                                     # Returns the date of the iDate
      ((@address / 10000).floor).modulo(31)
    end

    def print                              # Prints the address and event as csv
      puts "#{@address}, #{@event}"
    end

end

# ------------------------   MONTH CLASS   --------------------------- #
#
class Month                       # The number, name, && maximum number of days for a month

  def initialize year, number
    @number = number
    @year = year
    self.fill
  end

  def fill
    case @number
    when 1
      @name = "JANUARY"
      @max = 31
    when 2
      @name = "FEBRUARY"
        if year.modulo(4) == 0
          @max = 29
        else
          @max = 28
        end
    when 3
      @name = "MARCH"
      @max = 31
    when 4
      @name = "APRIL"
      @max = 30
    when 5
      @name = "MAY"
      @max = 31
    when 6
      @name = "JUNE"
      @max = 30
    when 7
      @name = "JULY"
      @max = 31
    when 8
      @name = "AUGUST ;)"
      @max = 31
    when 9
      @name = "SEPTEMBER"
      @max = 30
    when 10
      @name = "OCTOBER (SPOOKY)"
      @max = 31
    when 11
      @name = "NOVEMBER"
      @max = 30
    when 12
      @name = "DECEMBER"
      @max = 31
    end
  end

  def name
    @name
  end

  def max
    @max
  end

  def number
    @number
  end

  def year
    @year
  end

  def rotate                              #advances to the next month
    @number += 1
    self.fill
  end

  def print                       #returns as an array the header for the month
    ["\n","\n","|------------------ #{@name} #{@year} ------------------|","\n"]
  end

end

# ------------------------   WEEKNESS CLASS   --------------------------- #
#
class Weekness                      # The name && number of the day of the week for a day

  def initialize number
    @number = number
    self.name
  end

  def name
    case @number
    when 1
      @name = "MO"
    when 2
      @name = "TU"
    when 3
      @name = "WE"
    when 4
      @name = "TH"
    when 5
      @name = "FR"
    when 6
      @name = "SA"
    else
      @name = "SU"
    end
  end

  def number
    @number
  end

end

# ------------------------   DAY CLASS   --------------------------- #
#
class Day

  def initialize year, month, date, event
    @year = year
    @month = month
    @date = date
    @event = event
    @weekness = Weekness.new self.calcWeekness
    @address = self.calcshortAddress
  end

  def event
    @event
  end

  def max
    @max
  end

  def date
    @date
  end

  def string                          #Returns number as string, ensuring two digits
    if @date < 10
      "0#{@date}"
    else
      @date.to_s
    end
  end

  def month
    @month
  end

  def year
    @year
  end

  def address
    @address
  end

  def calcshortAddress
    (@month.number-1)*31+@date
  end

  def wName                                 # Returns the name of the day of the week
    @weekness.name
  end

  def wNumber                               # Returns the number of the day of the week
    @weekness.number
  end

  def calcWeekness                          #Calculates what day of the week the date is
    case @month.number
    when 1
      if @year.modulo(4) == 0
        ((doomAlg @year) + @date - 4).modulo(7)
      else
        ((doomAlg @year) + @date - 3).modulo(7)
      end
    when 2
      if year.modulo(4) == 0
        ((doomAlg @year) + @date - 29).modulo(7)
      else
        ((doomAlg @year) + @date - 28).modulo(7)
      end
    when 3
      ((doomAlg @year) + @date).modulo(7)
    when 4
      ((doomAlg @year) + @date - 4).modulo(7)
    when 5
      ((doomAlg @year) + @date - 9).modulo(7)
    when 6
      ((doomAlg @year) + @date - 6).modulo(7)
    when 7
      ((doomAlg @year) + @date - 11).modulo(7)
    when 8
      ((doomAlg @year) + @date - 8).modulo(7)
    when 9
      ((doomAlg @year) + @date - 5).modulo(7)
    when 10
      ((doomAlg @year) + @date - 10).modulo(7)
    when 11
      ((doomAlg @year) + @date - 7).modulo(7)
    when 12
      ((doomAlg @year) + @date - 12).modulo(7)
    end
  end

  def rotate                                # Advances the date to the next day of the month
    @date += 1
    @weekness = (Weekness.new self.calcWeekness)
    @address = self.calcshortAddress
  end

  def print                                 # returns an array containing text for calendar
    if self.wNumber == 1
      ["\n","#{self.string} #{self.wName} #{self.event} "]
    else
      ["#{self.string} #{self.wName} #{self.event} "]
    end
  end

end

# --------------------   CALENDAR CLASS   ------------------------ #

class Calendar                                        # Collection of Days

  def initialize year, m
    @year = year
    @m = m

    if @m == 0                              # Checks if this calendar is monthly or annual
      @maxM = 12
    else
      @maxM = @m
    end

    self.apollo
    self.compileCal

  end

  def apollo                                         # Adds Days to calendar

    @days = []

    if @m == 0                              # Checks if this calendar is monthly or annual
      month = Month.new @year, 1
    else
      month = Month.new @year, @m
    end

    while (month.number <= @maxM)

      today = 1

      while (today <= month.max)

        day = (Day.new @year, month, today, " ")
        @days[day.address] = day

        today += 1
      end

      month.rotate
    end

  end

  def compileCal                                      # Adds all important dates to @days

    (loadiDates).each do |a|

      if ((@m != 0) && (a.month != @m))                   #Skips writing if no important dates for the month
        next
      end

      self.pencilIn a
    end

  end

  def pencilIn iDate
    (@days[iDate.shortAddress]).event << iDate.event
  end

  def print                                       # Returns as array, text of a calendar

    if @m == 0
      calList = ["================== #{@year} ==================="]
    else
      calList = [""]
    end

    if @m == 0                              # Checks if this calendar is monthly or annual
      month = Month.new @year, 1
#      puts "Month #{month.number}"
    else
      month = Month.new @year, @m
#      puts "Month #{month.number}"
    end

    while (month.number <= @maxM)              # Assembles calendar text in array

      calList += month.print
      today = 1

      while (today <= month.max)
        calList += (@days[(makeShortAddress month, today)]).print
        today += 1
      end

      month.rotate
    end

    calList += ["$$$"]

    File.open $calendarFile, 'a' do |f|                 # Prints calendar text to file

      calList.each do |l|

        if l == "$$$"
          next
        end

        f.puts l
      end
    end

  end

end

# --------------------   DOOMSDAY ALGORITHM   ------------------------ #
#
def doomAlg year                       # Returns Doomsday Weekness for a given year in 2000s
  y = year - 2000
  ((y / 12).floor + y.modulo(12) + (y.modulo(12) / 4).floor).modulo(7) + 2
end

# ------------------------   importantDates   ---------------------------- #
#
def makeAddress year, month, date
  10000*((month.number-1)*31+date)+year
end

def makeShortAddress month, date
  (month.number - 1)*31+date
end

def addiDates address, event

  File.open $importantDates, 'a' do |f|
    f.puts "#{address} $$$ #{event}"
  end

end

def loadiDates

  brood = []

  (File.open $importantDates, 'r').each_line do |l|

    if l == "\n" || l == ""
     next
    end

    / \$\$\$ /.match(l)

    address = $`
    event = $'.delete!("\n")

    brood.push (Idate.new address, event)

  end

  return(brood)

end

# ---------------------------   MAIN   ------------------------------- #

puts
puts "What year?"                       # Code to print calendar
y = gets.to_i
puts
puts
puts "What month?"
m = gets.to_i
puts
puts

calendar = Calendar.new y, m

calendar.print

puts "Success!!"
puts
puts

# puts
# puts "What year?"                      # Code to save recurring important dates
# y = gets.to_i
# puts
# puts
# puts "What month?"
# m = gets.to_i
# puts
# puts
# puts "What date?"
# d = gets.to_i
# puts
# puts
# puts "What happened?"
# e = gets.chomp
# puts
# puts
#
# month = Month.new y, m
#
# addiDates (makeAddress y, month, d), e
#
# puts "Success!"
# puts
# puts
