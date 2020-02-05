# README

My testing is pretty rusty as my current position does not use test suites unless specifically chosen and paid for, 
favoring speed, to be able to quickly deliver an MVP to our clients for handover.

Driver
---

To start, I had wanted to break things down into smaller chunks.
Working to mimic Rails and ActiveRecord, I first created a Driver model. The model in my mind had many Trips and 
by extension, Trips belonged to a Driver. I started with a simple test for `assert_instance_of`. The driver has a name, 
so next I created a test showing the model can be instantiated with one and another showing there can be two models with
different names. Simple I know, but a quick happy/sad path for that. Next, for the trips, I showed that the model starts
with an empty array of trips and afterwards that trips can be added to it as the **_happy_** path.
For the **_sad_** path I showed that two different drivers have the same and differing trip information.

Trip
---

These tests were much simpler as a Trip simply `belongs_to` a Driver. There are simple happy and sad path tests for the three
attributes, `start_at`, `end_at`, and `distance`.  

Report
---

I named this `ReportGenerator` to avoid confusion with the `Report` that would be invoked from the command line.
To start, I wanted to initialize it with an input (the `ARGV` from the command line) and an empty array of drivers. The
drivers however are instantly created as when the report is instantiated, the _models_ are generated. My version of an
`after_commit` callback. 

I needed to show that I could separate the information for a driver and a trip. I used a simple regex to `#select`
the strings that started with `Driver` or `Trip`. From there I used another regex to isolate the driver's names and create
the Driver model. After which, I did the same with a regex for trip information to create that model, _associating_ them
the mentioned drivers.

With the _models_ made, I next started to work on the logic of calculating the total miles driven for each driver. Once, 
the total miles were calculated I could then sort the `ReportGenerator#drivers` to meet the ordering criteria of the challenge.
Next came calculating the average miles per hour, for which, the total time and distance driven for each driver needed to
be calculated.

Once the logic was completed, I simply mapped through the drivers array to return an interpolated array of strings with the
information required for the challenge, the driver's name followed by the total miles driven and average miles per hour.

Finally, I created a Report class that could be invoked from the command line with ARGV(`input.txt`). The class is initialized with the file,
passing it to the _generator_ and invoking the `ReportGenerator#generate_report` to return the array of interpolated information.
From there it is written to an `output.txt` file and `puts`'d to the screen.



