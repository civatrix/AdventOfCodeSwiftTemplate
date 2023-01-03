# AdventOfCodeSwiftTemplate
A template for completing [Advent of Code](www.adventofcode.com) challenges in Xcode using Swift. It's a CLI program with a template for each of the 25 days.

# Creation
Create a new repo using this a [template](https://github.com/civatrix/AdventOfCodeSwiftTemplate/generate). Because CLI tools can't include nonexecutable files in their binary, the tool has to know the path to the project. This defaults to `~/Documents/AdventOfCode` but is easily changed on line 12 of `AdventOfCode/main.swift`. I'm assuming this will only ever be run from within Xcode to facilitate debugging so there is very little error handling for the execution harness. 

# Use
The tool takes 3 arguments detailed below. Input can either be copy-pasted into the correct `DayX/input` file or by suppling a year and cookie parameter for the tool to fetch your input for you. This will only happen if the `input` file for that day is empty, and will save the fetched input to that file so it won't make another request each time you run the tool. If you're not using the auto input fetching, remove the `-y` and `-c` parameters from the scheme.

## -d (required)
Identifies the day you want to run. Used to select the correct `DayX` folder to get both executable code and input data. You'll need to change this each day before starting the next challenge.

## -y (optional)
Identifies the year you want to run. Used only when dynamically fetching your input. Also requires `-c` parameter to function

## -c (optional)
The cookie value used to dynamically fetch your input. Used only when dynamically fetching your input. Also requires `-y` parameter to function.

You can retrieve this by opening any `input` file on the [Advent of Code](www.adventofcode.com) site and using the developer tools `Network` tool. Reload the page with the tool open, select `input` and copy the entire value of the `Cookie` header including `session=`.  Duplicate `/AdventOfCode/Secrets.example.xcconfig` and rename it to `/AdventOfCode/Secrets.xcconfig` then paste it after the `=` on the only line. The cookies seem to be good for 30 days so if you do this at the end of November, you shouldn't need to touch it again  

# Tests
Included in each `DayX` folder is a Tests file. You can use this to test your code against example inputs provided in the challenges. By default it will run tests for all the days when you `Test` but you can select only certain days using `AdventOfCode.xctestplan` at the project root

# Output
When you run the program, you'll get a line indicating which day is running to confirm you have the correct parameter. After it's finished your result will be printed on it's own line and also copied to your pasteboard for easy submitting. I don't care about keeping part 1 results around once I start on part 2 so only a single result will ever be printed
