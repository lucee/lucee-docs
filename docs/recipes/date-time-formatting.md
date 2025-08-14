<!--
{
  "title": "Date and Time Formatting in Lucee",
  "id": "date-time-formatting",
  "since": "5.0",
  "categories": ["date", "time", "formatting", "localization"],
  "description": "Comprehensive guide to formatting dates and times in Lucee with locale and timezone support",
  "keywords": [
    "Date",
    "Time", 
    "Formatting",
    "Locale",
    "Timezone",
    "dateFormat",
    "timeFormat",
    "dateTimeFormat",
    "lsDateFormat",
    "createTime"
  ],
  "related": [
    "function-datetimeformat",
    "function-dateformat",
  ]
}
-->

# Date and Time Formatting in Lucee

Lucee provides powerful and flexible date and time formatting capabilities that support multiple locales, timezones, and custom format patterns. 

Whether you need basic date display, internationalized formatting, or complex timezone handling, Lucee's date formatting functions offer comprehensive solutions for any application.

## Overview

Date and time formatting in Lucee allows you to convert date objects into human-readable strings according to specific patterns, locales, and timezones. 

The formatting system supports everything from simple date displays to complex internationalized applications with multiple timezone support.

## How It Works

Lucee's date formatting system works by taking a date object and applying formatting rules based on:

1. **Format patterns** - Define how the date should appear (e.g., "yyyy-MM-dd")
2. **Locales** - Determine language and regional formatting conventions
3. **Timezones** - Handle timezone conversions and display
4. **Date objects** - Work with various date types including Date, DateTime, and Time objects

**Important:** Lucee uses `java.util.Date` internally, which **never holds timezone information**. 

Date objects represent a specific moment in time (milliseconds since Unix epoch). Timezone and locale are only applied when:

- **Creating/Parsing** a date from human-readable values (to interpret what moment in time those values represent)
- **Formatting** a date object into a string (to display that moment in a specific timezone)

Once created, the date object itself has no timezone - it's just a moment in time.

```javascript
// Timezone used during CREATION to interpret the input values
eventDate = createDateTime(2025, 6, 20, 12, 0, 0, 0, "Europe/Berlin");
// This means: "Create a date representing the moment when it was 12:00 in Berlin"

// The resulting eventDate object has NO timezone information attached
// It's just a absolute moment in time (milliseconds since epoch)

// Timezone used during FORMATTING to display that moment
echo(dateTimeFormat(eventDate, "HH:mm Z", "UTC"));           // 10:00 +0000
echo(dateTimeFormat(eventDate, "HH:mm Z", "America/New_York")); // 06:00 -0400
echo(dateTimeFormat(eventDate, "HH:mm Z", "Asia/Tokyo"));    // 19:00 +0900

// Same date object (same moment in time), different timezone displays
```

The formatting functions process these inputs and return formatted strings suitable for display or storage.

## Configuration

You can configure default locale and timezone settings at different levels:

### Global Configuration

Set defaults in Lucee Admin or `.CFConfig.json`:

```json
{
  "locale": "en_US",
  "timezone": "Europe/Zurich"
}
```

### Application Level

Configure in `Application.cfc`:

```javascript
component {
    this.locale = "en_US";
    this.timezone = "Europe/Zurich";
}
```

### Runtime Configuration

Set locale and timezone dynamically in your code:

```javascript
// Set and get locale
setLocale("de_DE");
currentLocale = getLocale(); // Returns: de_DE

// Set and get timezone
setTimeZone("Europe/Berlin");
currentTimezone = getTimeZone(); // Returns: Europe/Berlin

// These settings affect subsequent formatting operations
echo(lsDateFormat(now(), "full")); // Uses current locale
echo(dateTimeFormat(now(), "yyyy-MM-dd HH:mm:ss z")); // Uses current timezone
```

## Understanding Date Objects in Lucee

### Creating Dates with Timezone Context

When creating dates, you can specify a timezone to **interpret** what timezone the input values represent during creation. 

The resulting date object is still a `java.util.Date` with no timezone attached:

```javascript
// These create DIFFERENT date objects representing different moments in time
// The timezone parameter is used to INTERPRET the input values during creation

// "12:00 noon on June 20, 2025 interpreted as UTC time" 
date1 = createDateTime(2025, 6, 20, 12, 0, 0, 0, "UTC");

// "12:00 noon on June 20, 2025 interpreted as New York time" (which is 16:00 UTC during DST)
date2 = createDateTime(2025, 6, 20, 12, 0, 0, 0, "America/New_York");

// "12:00 noon on June 20, 2025 interpreted as Tokyo time" (which is 03:00 UTC)  
date3 = createDateTime(2025, 6, 20, 12, 0, 0, 0, "Asia/Tokyo");

// All resulting objects are plain java.util.Date with no timezone info
// The timezone was only used during creation to determine the moment in time

// All formatted in UTC to see the actual moments they represent:
echo(dateTimeFormat(date1, "HH:mm Z", "UTC"));     // 12:00 +0000
echo(dateTimeFormat(date2, "HH:mm Z", "UTC"));     // 16:00 +0000 
echo(dateTimeFormat(date3, "HH:mm Z", "UTC"));     // 03:00 +0000

// Using named parameters for clarity - timezone only used during creation
meetingTime = createDateTime(
    year: 2025,
    month: 6, 
    day: 20,
    hour: 12,
    timezone: "Europe/Berlin"  // Interpret "12:00" as "12:00 Berlin time"
);

// meetingTime is now a plain Date object representing that moment in time
// You still need timezone when formatting:
echo(dateTimeFormat(meetingTime, "HH:mm z", "Europe/Berlin"));  // 12:00 CEST
echo(dateTimeFormat(meetingTime, "HH:mm z", "UTC"));           // 10:00 UTC
```

### Parsing Dates with Timezone Context

Similarly, when parsing date strings, you can specify the timezone to **interpret** what timezone the string values represent. 

The resulting date object is still a plain `java.util.Date`:

```javascript
// Parse date strings with timezone context for interpretation
userInput = "2025-06-20 14:30:00";

// These create different date objects depending on how you interpret the input:
date1 = parseDateTime(userInput, "yyyy-MM-dd HH:mm:ss", "UTC");
// Interprets as: "14:30 UTC time"

date2 = parseDateTime(userInput, "yyyy-MM-dd HH:mm:ss", "Europe/Berlin");  
// Interprets as: "14:30 Berlin time"

// Both are plain Date objects now, timezone was only used during parsing
// Same input string, different moments in time:
echo(dateTimeFormat(date1, "HH:mm Z", "UTC"));     // 14:30 +0000
echo(dateTimeFormat(date2, "HH:mm Z", "UTC"));     // 12:30 +0000 (2 hours earlier)

// You still need to specify timezone when formatting either date:
echo(dateTimeFormat(date1, "HH:mm z", "Europe/Berlin"));    // 16:30 CEST  
echo(dateTimeFormat(date2, "HH:mm z", "Europe/Berlin"));    // 14:30 CEST
```

### Keep Dates as Objects

The principle is to keep dates as date objects as long as possible:

```javascript
// Good: Work with date objects
userBirthday = createDate(1990, 5, 15, "UTC");
yearsOld = dateDiff("y", userBirthday, now());

// Good: Store date objects in database
queryExecute("INSERT INTO users (birthday) VALUES (?)", [userBirthday]);

// Good: Pass date objects between functions
function calculateAge(birthDate) {
    return dateDiff("yyyy", birthDate, now());
}

// Only format when you need to display to users
function displayBirthday(birthDate, userLocale, userTimezone) {
    return lsDateFormat(birthDate, "long", userLocale);
}
```

### Avoid String Conversions

```javascript
// Avoid: Converting to strings unnecessarily
originalDate = createDateTime(2025, 6, 20, 12, 0, 0, 0, "UTC");
dateString = dateFormat(originalDate, "yyyy-mm-dd");
// ... do some operations ...
backToDate = parseDateTime(dateString); // Potential for errors

// Better: Keep as date object
originalDate = createDateTime(2025, 6, 20, 12, 0, 0, 0, "UTC");
// ... do operations with date functions ...
result = dateAdd("d", 7, originalDate); // Still a date object
```

## Implementation

### Step 1: Creating and Basic Date Formatting

Start with creating dates and simple formatting:

```javascript
// Create dates with different methods
today = now();
specificDate = createDateTime(2025, 6, 20, 15, 30, 45);

// Create dates with timezone context
utcDate = createDateTime(2025, 6, 20, 12, 0, 0, 0, "UTC");
nyDate = createDateTime(2025, 6, 20, 12, 0, 0, 0, "America/New_York");

// These represent different moments in time!
echo(dateTimeFormat(utcDate, "yyyy-MM-dd HH:mm:ss Z", "UTC"));
// Output: 2025-06-20 12:00:00 +0000

echo(dateTimeFormat(nyDate, "yyyy-MM-dd HH:mm:ss Z", "UTC"));  
// Output: 2025-06-20 16:00:00 +0000 (4 hours later!)

// Using named parameters for clarity
parisDate = createDateTime(
    year: 2025,
    month: 6, 
    day: 20,
    hour: 12,
    timezone: "Europe/Paris"
);

// Basic date formatting
echo(dateFormat(today));                    // 20-Jun-2025 (default format)
echo(dateFormat(today, "yyyy-mm-dd"));      // 2025-06-20
echo(dateFormat(today, "dd/mm/yyyy"));      // 20/06/2025
echo(dateFormat(today, "mmmm d, yyyy"));    // June 20, 2025

// Basic time formatting  
echo(timeFormat(today));                    // 14:30:45 (default format)
echo(timeFormat(today, "HH:mm:ss"));        // 14:30:45
echo(timeFormat(today, "h:mm tt"));         // 2:30 PM
echo(timeFormat(today, "HH:mm"));           // 14:30

// Combined date and time
echo(dateTimeFormat(today, "yyyy-MM-dd HH:mm:ss"));  // 2025-06-20 14:30:45
```

### Step 2: Working with Custom Format Patterns

Use specific format patterns for precise control:

```javascript
testDate = createDateTime(2025, 6, 20, 15, 30, 45, 0, "UTC");

// Year formats
echo(dateFormat(testDate, "yy"));           // 25
echo(dateFormat(testDate, "yyyy"));         // 2025

// Month formats  
echo(dateFormat(testDate, "m"));            // 6
echo(dateFormat(testDate, "mm"));           // 06
echo(dateFormat(testDate, "mmm"));          // Jun
echo(dateFormat(testDate, "mmmm"));         // June

// Day formats
echo(dateFormat(testDate, "d"));            // 20
echo(dateFormat(testDate, "dd"));           // 20
echo(dateFormat(testDate, "ddd"));          // Fri
echo(dateFormat(testDate, "dddd"));         // Friday

// Time patterns
echo(timeFormat(testDate, "H"));            // 15 (24-hour)
echo(timeFormat(testDate, "HH"));           // 15 (24-hour with leading zero)
echo(timeFormat(testDate, "h"));            // 3 (12-hour)
echo(timeFormat(testDate, "hh"));           // 03 (12-hour with leading zero)
echo(timeFormat(testDate, "mm"));           // 30 (minutes)
echo(timeFormat(testDate, "ss"));           // 45 (seconds)
echo(timeFormat(testDate, "tt"));           // PM (AM/PM indicator)
```

### Step 3: Timezone Handling

Format dates in different timezones:

```javascript
// Create a specific date/time
eventTime = createDateTime(2025, 6, 20, 12, 0, 0, 0, "UTC");

// Format in different timezones
echo(dateTimeFormat(eventTime, "yyyy-MM-dd HH:mm:ss Z", "UTC"));
// Output: 2025-06-20 12:00:00 +0000

echo(dateTimeFormat(eventTime, "yyyy-MM-dd HH:mm:ss Z", "America/New_York"));  
// Output: 2025-06-20 08:00:00 -0400

echo(dateTimeFormat(eventTime, "yyyy-MM-dd HH:mm:ss Z", "Europe/Berlin"));
// Output: 2025-06-20 14:00:00 +0200

echo(dateTimeFormat(eventTime, "yyyy-MM-dd HH:mm:ss z", "Asia/Tokyo"));
// Output: 2025-06-20 21:00:00 JST

// Working with DST (Daylight Saving Time)
summerDate = createDateTime(2025, 7, 15, 12, 0, 0, 0, "UTC");  // Summer
winterDate = createDateTime(2025, 1, 15, 12, 0, 0, 0, "UTC");  // Winter

echo(dateTimeFormat(summerDate, "Z", "Europe/Berlin"));  // +0200 (CEST)
echo(dateTimeFormat(winterDate, "Z", "Europe/Berlin"));  // +0100 (CET)
```

### Step 4: Locale-Aware Formatting

Use localized formatting for international applications:

```javascript
testDate = createDateTime(2025, 6, 20, 14, 30, 45, 0, "UTC");

// Predefined locale formats
echo(lsDateFormat(testDate, "short", "en_US"));      // 6/20/25
echo(lsDateFormat(testDate, "medium", "en_US"));     // Jun 20, 2025
echo(lsDateFormat(testDate, "long", "en_US"));       // June 20, 2025
echo(lsDateFormat(testDate, "full", "en_US"));       // Friday, June 20, 2025

// Different locales
echo(lsDateFormat(testDate, "long", "de_DE"));       // 20. Juni 2025
echo(lsDateFormat(testDate, "long", "fr_FR"));       // 20 juin 2025
echo(lsDateFormat(testDate, "long", "es_ES"));       // 20 de junio de 2025
echo(lsDateFormat(testDate, "long", "ja_JP"));       // 2025年6月20日

// Localized time formatting
echo(lsTimeFormat(testDate, "short", "en_US"));      // 2:30 PM
echo(lsTimeFormat(testDate, "medium", "en_US"));     // 2:30:45 PM
echo(lsTimeFormat(testDate, "short", "de_DE"));      // 14:30
echo(lsTimeFormat(testDate, "medium", "fr_FR"));     // 14:30:45

// Combined date and time with locale
echo(lsDateTimeFormat(testDate, "short", "en_US"));  // 6/20/25, 2:30 PM
echo(lsDateTimeFormat(testDate, "full", "de_DE"));   // Freitag, 20. Juni 2025 um 14:30:45 MESZ
```

### Step 5: Working with Time Objects

Handle time-only objects created with `createTime()`:

```javascript
// Create time-only objects
morningTime = createTime(8, 30, 0, "UTC");
eveningTime = createTime(18, 45, 30, "UTC");

// Format time objects
echo(timeFormat(morningTime, "h:mm tt"));           // 8:30 AM
echo(timeFormat(eveningTime, "HH:mm:ss"));          // 18:45:30

// Time objects with timezone (Note: uses 1899-12-30 as base date)
echo(dateTimeFormat(morningTime, "HH:mm:ss Z", "Europe/Zurich"));
// Output: 08:30:00 +0100

// Localized time formatting
echo(lsTimeFormat(morningTime, "short", "en_US"));  // 8:30 AM
echo(lsTimeFormat(morningTime, "short", "de_DE"));  // 08:30
```

### Step 6: Advanced Formatting Patterns

Create complex format patterns for specific needs:

```javascript
currentDate = now();

// ISO 8601 format
echo(dateTimeFormat(currentDate, "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'", "UTC"));
// Output: 2025-06-20T14:30:45.123Z

// RFC 2822 format  
echo(dateTimeFormat(currentDate, "EEE, dd MMM yyyy HH:mm:ss Z"));
// Output: Fri, 20 Jun 2025 14:30:45 +0200

// Custom readable format
echo(dateTimeFormat(currentDate, "EEEE, MMMM d, yyyy 'at' h:mm a"));
// Output: Friday, June 20, 2025 at 2:30 PM

// Filename-safe format
echo(dateTimeFormat(currentDate, "yyyy-MM-dd_HH-mm-ss"));
// Output: 2025-06-20_14-30-45

// Week and day of year
echo(dateFormat(currentDate, "yyyy-'W'ww-F"));      // 2025-W25-5 (Week 25, Day 5)
echo(dateFormat(currentDate, "yyyy-DDD"));          // 2025-171 (Day 171 of year)
```

## Lucee 6.1 vs 6.2 Implementation Changes

### What Changed in Lucee 6.2

In Lucee 6.2, the underlying implementation was upgraded from Java's legacy `SimpleDateFormat` to the modern `DateTimeFormatter` API. This change brings improved performance and thread safety, but introduced some differences in historical timezone handling.

### The Key Difference

```javascript
// Example with historical date and Europe/Helsinki timezone

// Lucee 6.1 and earlier (SimpleDateFormat)
myDate = createDateTime(1905, 12, 24, 17, 39, 49, 0, "UTC");
result = dateTimeFormat(myDate, "yyyy-MM-dd HH:mm:ss Z", "Europe/Helsinki");
// Output: 1905-12-24 19:39:49 +0200 (modern offset)

// Lucee 6.2+ (DateTimeFormatter)  
myDate = createDateTime(1905, 12, 24, 17, 39, 49, 0, "UTC");
result = dateTimeFormat(myDate, "yyyy-MM-dd HH:mm:ss Z", "Europe/Helsinki");
// Output: 1905-12-24 19:19:38 +0139 (historically accurate 1905 offset)
```

### Why This Happened

- `SimpleDateFormat` often ignores historical timezone changes for dates before certain cutoffs
- `DateTimeFormatter` applies complete IANA timezone database including all historical transitions
- For actual historical dates (like 1905), the new historically accurate behavior is technically correct

### Current Behavior

Modern Lucee versions automatically detect and handle synthetic date issues:

- **`createTime()` objects** with synthetic dates before 1899-12-31 use standard timezone offsets (the fix)
- **Actual historical dates** (like 1905-12-24) continue to use historically accurate timezone rules (no fix needed)
- **Modern dates** continue to use full timezone rules including DST
- No breaking changes to existing APIs
- Performance improvements from the DateTimeFormatter migration

## Best Practices

### 1. Always Specify Timezone for User-Facing Dates

```javascript
// Good: Explicit timezone
userDate = dateTimeFormat(now(), "yyyy-MM-dd HH:mm:ss z", session.userTimezone);

// Better: Include offset for clarity
userDate = dateTimeFormat(now(), "yyyy-MM-dd HH:mm:ss Z (z)", session.userTimezone);
```

### 2. Work with Dates as Objects, Format with Timezone

The best practice is to keep dates as date objects and only apply timezone/locale when formatting:

```javascript
// Store dates as date objects (no timezone attached)
function storeUserEvent(eventDate) {
    // Date objects don't have timezone - they represent a moment in time
    queryExecute("INSERT INTO events (event_date) VALUES (?)", [eventDate]);
}

// Display with user's preferred timezone
function displayUserEvent(eventDate, userTimezone) {
    // Same date object, formatted for user's timezone
    return dateTimeFormat(eventDate, "MMM d, yyyy 'at' h:mm a z", userTimezone);
}

// Example: Same event, different user timezones
eventDate = createDateTime(2025, 6, 20, 18, 0, 0); // 6 PM on June 20, 2025

// User in New York sees:
echo(displayUserEvent(eventDate, "America/New_York")); // Jun 20, 2025 at 2:00 PM EDT

// User in Tokyo sees:  
echo(displayUserEvent(eventDate, "Asia/Tokyo"));       // Jun 21, 2025 at 3:00 AM JST

// User in London sees:
echo(displayUserEvent(eventDate, "Europe/London"));    // Jun 20, 2025 at 7:00 PM BST
```

**Note:** Avoid `dateConvert("local2utc", date)` - this function exists only for ACF compatibility and can be misleading since date objects don't actually hold timezone information (in ACF and Lucee).

### 3. Use Appropriate Format Functions

```javascript
// For system/API dates - use consistent format
apiDate = dateTimeFormat(now(), "yyyy-MM-dd'T'HH:mm:ss'Z'", "UTC");

// For user display - use localized format  
userDate = lsDateTimeFormat(now(), "medium", session.userLocale, session.userTimezone);

// For file names - use safe characters
fileName = "report_" & dateTimeFormat(now(), "yyyy-MM-dd_HH-mm-ss") & ".pdf";
```

Lucee's date and time formatting capabilities provide a robust foundation for handling dates in any application, from simple displays to complex international systems. Understanding the various functions, their parameters, and best practices ensures your application handles dates correctly across different locales and timezones.