<!--- try this example in your code--->
<cfoutput>
  <!--- the below code increments 10 miliseconds in actual date--->
  #dateAdd("l",now(),10)#
  <!--- the below code increments 60 seconds in actual date--->
  #dateAdd("s",now(),60)#
  <!--- the below code increments 60 minutes in actual date--->
  #dateAdd("n",now(),60)#
  <!--- the below code increments 2 hours in actual date--->
  #dateAdd("h",now(),2)#
  <!--- the below code increments 1 day in actual date--->
  #dateAdd("d",now(),1)#
  <!--- the below code increments 1 month in actual date--->
  #dateAdd("m",now(),1)#
  <!--- the below code increments 1 year in actual date--->
  #dateAdd("yyyy",now(),1)#
</cfoutput>
