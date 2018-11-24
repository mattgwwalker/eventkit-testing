//
//  EventKit_Test_DemoTests.swift
//  EventKit Test DemoTests
//
//  Created by Matthew Walker on 24/11/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import EventKit
import XCTest
@testable import EventKit_Test_Demo

class EventKitUserTest: XCTestCase {
    
    // Create calendar
    func createCalendar(eventStore: EKEventStore, title: String) throws -> EKCalendar {
        let calendar = EKCalendar(for: .event, eventStore: eventStore)
        calendar.source = eventStore.defaultCalendarForNewEvents!.source
        calendar.title = title
        try eventStore.saveCalendar(calendar, commit: true)
        return calendar
    }
    
    
    // Create event for given times
    func createEvent(eventStore: EKEventStore, calendar: EKCalendar, title: String, startDate: Date, endDate: Date) throws -> EKEvent {
        let event = EKEvent(eventStore: eventStore)
        event.calendar = calendar
        event.title = title
        event.startDate = startDate
        event.endDate = endDate
        try eventStore.save(event, span: .thisEvent)
        return event
    }
    
    
    func testWithEvent() throws {
        // Get the event store
        let eventStore = EventStore.getInstance()

        // Request calendar access
        EventStore.requestAccess()

        // Create calendar
        let calendar = try createCalendar(eventStore: eventStore, title: "Test Calendar")
        
        // Calculate the start of tomorrow
        let twentyFourHours = Double(24 * 60 * 60)
        let tomorrow = Calendar.current.startOfDay(for: Date() + twentyFourHours)
        
        // Create event detailing available time for tomorrow
        let event =
            try createEvent(eventStore: eventStore,
                            calendar: calendar,
                            title: "Test Event",
                            startDate: Calendar.current.date(byAdding: DateComponents(hour: 9), to: tomorrow)!,
                            endDate: Calendar.current.date(byAdding: DateComponents(hour: 10), to: tomorrow)!)
        
        // *****************************************
        // Test code that uses the calendar or event
        // *****************************************

        // Remove the calendar after testing
        try eventStore.removeCalendar(calendar, commit: true)
    }
}
