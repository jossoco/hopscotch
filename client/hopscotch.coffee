getDayForDate = (date) ->
    date = moment(date)
    date = date.subtract(1, 'days') if date.hours() < 2  # If time is 12am-2am, treat as part of previous day.
    date.format('dddd')

Template.hopscotchSchedule.rendered = ->
    $('.act:not(.static-font-size)').boxfit({
        multiline: true
        maximum_font_size: 12
        minimum_font_size: 9
    })

Template.hopscotchSchedule.helpers
    getVenues: ->
        _.values(HopscotchData.VENUES)

    getGenres: ->
        _.values(HopscotchData.GENRES)

    getEventData: ->
        events = _.sortBy(HopscotchData.EVENTS, (event) -> event.date)
        events = _.groupBy(events, (event) -> event.date)

        # Flag each day's first date for use in display.
        datesByDay = {}
        dates = _.map _.keys(events), (date) ->
            day = getDayForDate(date)
            first = not datesByDay[day]?
            datesByDay[day] = true
            {date: date, first: first}

        {dates: dates, events: events}

    getEventsForDate: (data) ->
        events = data.events[@date]
        events = _.groupBy(events, (event) -> event.venue.name)

    formatTime: (date) ->
        moment(date or @date).format('h:mm')

    getDay: ->
        getDayForDate(@date)

    getVenueEvent: (venue) ->
        @[venue.name]?[0]

    getDayRowSpan: (events) ->
        datesByDay = _.groupBy(events.dates, (date) -> getDayForDate(date.date))
        datesByDay[getDayForDate(@date)].length

    getRowClass: ->
        if @first then 'day' else ''

    getCityPlazaEvents: ->
        HopscotchData.CITY_PLAZA_EVENTS[moment(@date).format('YYYY-MM-DD')]

    getActClass: ->
        @class or ''

    getLegendColSpan: ->
        _.size(HopscotchData.VENUES) + 1  # Add one for time cell.
