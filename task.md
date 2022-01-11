# Interview assignment Frontend Engineer

### Overview

As a software service provider for the cinema industry, one of the core tools that we build is a timeline for movie screenings. The timeline lets you schedule your program for the week, and also lets you visualize todays screenings across many screens. To do this we need to map mouse positions on the timeline to actual times.

We’d like you to create a quick prototype of a timeline where mouse pointer hovering maps onto a specific time of day. You must use the Elm programming language for this.

The prototype does not have to look nice, i.e there are no requirements for styling. You can use any library that you’re used to and find useful.

### Specification

- A container that spans the width of the screen minus padding
- The left-most point in the container maps to 00:00 for the current day
- The right-most point in the container maps to 23:59 for the current day
- The center point in the container maps to 12:00 for the current day
- Granularity for translated times should be 1 minute
- The time mapping must be timezone aware, and use the browsers current timezone
- The currently hovered time must be stored on the model as a `Posix` time
- Display the currently hovered time somewhere on the page
- We must be able to download and run the code locally

### Bonus

- Add a 10 minute snap interval checkbox that toggles if the granularity of the translation should be 1 minute or 10 minutes
    - I.e. the time should snap to the nearest whole 10 minutes

### Tips

- Use create-elm-app to quickly get an app up and running
- The [Html.Events.Extra.Mouse](https://package.elm-lang.org/packages/mpizenberg/elm-pointer-events/latest/Html.Events.Extra.Mouse) package has an [onMove](https://package.elm-lang.org/packages/mpizenberg/elm-pointer-events/latest/Html-Events-Extra-Mouse#onMove) event that is useful for getting information about the position of the `mousemove` event
- This assignment is meant to take about 2 hours to complete.

