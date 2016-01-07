#***************************************** DATE functions in R **********************************

#Dates are represented as the number of days since 1970-01-01, with negative values for earlier dates. 


Sys.time() # returns an absolute date-time value ******************e.g "2016-01-07 12:06:22 IST"

Sys.Date() # returns the current day in the current time zone.***********e.g "2016-01-07"

date()   # returns the current date and time in character format. e.g "Thu Jan 07 12:14:30 2016"

# The following symbols can be used with the format( ) function to print dates. 


# %d  ******** day as a number (0-31)
# %a  ******** abbreviated weekday Mon
# %A  ******** unabbreviated weekday Monday
# %m  ******** month (00-12) 
# %b  ******** abbreviated month Jan
# %B  ******** unabbreviated month January
# %y  ******** 2-digit year 07
# %Y  ******** 4-digit year 2007

# print today's date
today <- Sys.Date()
format(today, format="%d %a %A %m %b %B %Y")

#Character to Date conversion

strDates <- c("01/05/1965", "08/16/1975")
str(strDates)
dates <- as.Date(strDates, "%m/%d/%Y") 


# The default format is yyyy-mm-dd
mydates <- as.Date(c("2007-06-22", "2004-02-13"))


#Date to Character conversion
strDates <- as.character(dates)
str(strDates)



#************************ LUBRIDATE PACKAGE IN R**************************

#Lubridate's parse functions  ymd,mdy,dmy, ymd_hms
ymd("20110604")

mdy("06-04-2011")

dmy("04/06/2011")

ymd_hms("2011-06-04 12:00:00", tz = "Pacific/Auckland")

# Extract information from date times with the functions second, minute, hour, day, wday, yday, week, month, year, and tz

second("2011-06-04 12:00:00")   minute("2011-06-04 12:00:00")   hour("2011-06-04 12:00:00")  day("2011-06-04 12:00:00")
wday("2011-06-04 12:00:00")     yday("2011-06-04 12:00:00")     week("2011-06-04 12:00:00")  month("2011-06-04 12:00:00")
tz("2011-06-04 12:00:00") 


wday("2011-06-04 12:00:00",label = TRUE)

#*****************************************************

#Time Zones

# display the same moment in a different time zone ** with_tz

meeting <- ymd_hms("2011-07-21 09:00:00", tz = "Pacific/Auckland") # 9.00 am in Auckland New Zealand? what time will this be in Chicago

with_tz(meeting, "America/Chicago")  # will be 16.00 in Chicago and the previous day.

# force_tz forces a time in one zone to the other zone.The numbers dont change

mistake <- force_tz(meeting, "America/Chicago")
with_tz(mistake, "Pacific/Auckland")

#*****************************************************
