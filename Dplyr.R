#********* DPLYR package in R
# credits http://www.r-bloggers.com/hands-on-dplyr-tutorial-for-faster-data-manipulation-in-r/

# Five basic verbs: filter, select, arrange, mutate, summarise (plus group_by)

library(hflights) # sample data
head(hflights)

# convert to local data frame  [ a local data frame is only a wrapper for a data frame that prints nicely according to the screen size e.g print hflights and flights to know]
flights=tbl_df(hflights)

# a local data frame shows only 10 rows by default. 

# you can specify u wawnt to see more rows

print(flights,n=20)

# to convert a local data frame to a normal data frame use

data.frame(head(flights))

#*******************************************   filter**********************************************************************
#***************************************************************************************************************************

##filter : Keep rows matching criteria

# base R approach to view all flights on Jan1
flights[flights$Month==1 & flights$DayofMonth==1,]

# dplyr approach

filter(flights,Month==1 & DayofMonth==1)  # we can use comma or ampersand to represent AND condition

# use pipe for OR condition
filter(flights,UniqueCarrier=="AA" | UniqueCarrier=="UA")   # note we have to enter the Column name twice. To avoid this use %in%

# %in% operator
filter(flights,UniqueCarrier %in% c("UA","AA"))


#*******************************************   select **********************************************************************
#***************************************************************************************************************************

# base R approach to select columns DepTime,ArrTime and FlightNum
flights[,c("DepTime","ArrTime","FlightNum")]

# dplyr approach

select(flights,DepTime,ArrTime,FlightNum)

# use colon : to select multiple contiguous columns and use 'contains'to match columns by name
#  'starts_with', 'ends_with' and 'matches' can also be used to match columns by name

select(flights,Year:DayofMonth,contains("Taxi"),contains("Delay"))

select(flights,starts_with("Y"),ends_with("h"),matches("epDela"))

# ************* chaining or Pipelining

# used in place of nesting commands in a natural order by using the '%>%' ( prounounced as THAN)

# e.g Find all Unique Carrier and their DepDelay for whom DepDelay>60

#Normally we would do it like this
 
filter(select(flights,UniqueCarrier,DepDelay),DepDelay>60)


# using THAN we will do it like this

flights %>%
  select(UniqueCarrier,DepDelay) %>%
     filter(DepDelay > 60)
  
#******************************************* arrange **(reorder rows)*******************************************************
#***************************************************************************************************************************    

# base R approach to select UniqueCarrier and DepDelay columns and sort by DepDelay

flights[ order(flights$DepDelay),c("UniqueCarrier","DepDelay")]         # increasing order
flights[ order(desc(flights$DepDelay)),c("UniqueCarrier","DepDelay")]   # desreasing order

# dplyr approach

flights %>%
  select(UniqueCarrier,DepDelay)%>%
    arrange(DepDelay)


flights %>%
  select(UniqueCarrier,DepDelay)%>%
  arrange(desc(DepDelay))


#******************************************* mutate **(add new variables)***************************************************
#***************************************************************************************************************************    

#create new variables that are functions of existing variable

# base R approach to create a new variable Speed (mph)

flights$Speed=flights$Distance/flights$AirTime*60
flights[,c("Distance","AirTime","Speed")]

# dplyr approach (prints a new variables but does not store it in the data frame)

flights %>%
  select(Distance,AirTime) %>%
     mutate(Speed=Distance/AirTime*60)

# to store the variable
flights=flights %>% mutate(Speed=Distance/AirTime*60)
   

#******************************************* summarise **(reduce variables to values)***************************************
#***************************************************************************************************************************    

#base R approach to calculate the average arrival delay to each destination

head(tapply(flights$ArrDelay,flights$Dest,mean,na.rm=T),10)

# dplyr approach: create a table grouped by Dest, then summarise each group by taking mean of ArrDelay

flights %>%
   group_by(Dest) %>%
     summarise(ArrDelay=mean(ArrDelay,na.rm=T))


# summarise_each --allows to apply the same function to multiple columns at once --mutate_each is also available

# for each carrier, calculate the percentage of flights cancelled or diverted

flights %>%
   group_by(UniqueCarrier) %>%
       summarise_each(funs(mean),Cancelled,Diverted)

# if we used summarise for the above we would have to write two functions

flights %>%
  group_by(UniqueCarrier) %>%
    summarise(mean(Cancelled))

# and 

flights %>%
  group_by(UniqueCarrier) %>%
    summarise(mean(Diverted))



# for each carrier, calculate the minimum and maximum arrival and departure delays

flights %>%
   group_by(UniqueCarrier) %>%
      summarise_each(funs(min(.,na.rm=T),max(.,na.rm=T)),matches("Delay"))     # '.' is the placeholder for the data we are passing



#***************  n() counts the total number of rows in a group
#***************n_distinct(vector) counts the number of unique items in that vector

# for each day of the year, count the total number of flights and sort in descending order

flights %>%
   group_by(Month,DayofMonth) %>%
       summarise(flight_count=n()) %>%
          arrange(desc(flight_count))


# rewrite more simply with the tally function


flights %>%
  group_by(Month,DayofMonth) %>%
     tally(sort=T)
# only problem here is we cant define the column name. it is n

# for each destination, count the total number of flights and the number of distinct planes that flew there.
flights %>%
    group_by(Dest)%>%
        summarise(flight_count=n(),plane_count=n_distinct(TailNum))



# for each destination show the number of cancelled and not cancelled flights

flights %>%
  group_by(Dest)%>%
      select(Cancelled) %>%
         table(.) %>%
            head()
      
     
# windows functions

#Aggregation function (like mean) takes n inputs and returns 1 value
#Window function takes n inputs and returns n values
    
#Includes ranking and ordering functions (like min_rank), offset functions (lead and lag), and cumulative aggregates (like cummean).


# for each carrier, calculate which two days of the year that had their longest departure delays

flights%>%
  group_by(UniqueCarrier)%>%
    select(UniqueCarrier,Month,DayofMonth,DepDelay) %>%
      filter(min_rank(desc(DepDelay))<=2)%>%
        arrange(UniqueCarrier,desc(DepDelay))


# note: smallest (not largest) value is ranked as 1, so you have to use `desc` to rank by largest value


flights%>%
  group_by(UniqueCarrier) %>%
  select(UniqueCarrier,Month,DayofMonth,DepDelay) %>%
    top_n(2) %>%
  arrange(UniqueCarrier,desc(DepDelay))

#  top_n(2)----> by default it selects DepDelay. U can also specify a particular column



# for each month calculate the number of flights and the changes from the previous month

flights %>%
  group_by(Month) %>%
    summarise(total_flight=n()) %>%
     mutate(Change=total_flight - lag(total_flight))
     
     
# rewrite more simply with the tally function *****  tally is useful when we have summarise and the n()

flights %>%
  group_by(Month) %>%
  tally() %>%
  mutate(Change=n-lag(n))

# other useful Functions

# randomly sample a fixed number of rows, without replacement

flights %>% sample_n(5)

#randomly sample a fixed fraction of rows, with replacement 

flights %>% sample_frac(0.85,replace=T)


# base R approach to view the structure of an object
str(flights)


# dplyr approach

glimpse(flights)



# Connecting to DataBases
#dplyr can connect to a database as if the data was loaded into a data frame
#Use the same syntax for local data frames and databases
#Only generates SELECT statements
#Currently supports SQLite, PostgreSQL/Redshift, MySQL/MariaDB, BigQuery, MonetDB



# https://cran.r-project.org/web/packages/dplyr/vignettes/databases.html


# IMPORTANT READ THE ABOVE 












  













