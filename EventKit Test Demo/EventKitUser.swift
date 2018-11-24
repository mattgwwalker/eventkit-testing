//
//  EventKitUser.swift
//  EventKit Test Demo
//
//  Created by Matthew Walker on 24/11/18.
//  Copyright © 2018 Matthew Walker. All rights reserved.
//

import Foundation
import EventKit

// An extension to Notification so that we can be notified when a call to requestAccess
// completes.
extension Notification.Name {
    static let DidRequestEventStoreAccess = Notification.Name("DidRequestEventStoreAccess")
}


// A singleton that gives access to an Event Store.
// Register for notifications under "EKEventStoreChanged" to be updated wheverever
// the event store changes (for example, if a calendar event is added or deleted).
// Register for notifications under "DidRequestEventStoreAccess" to be updated when
// the call to requestAccess completes (for example when the user allows calendar
// access).
class EventStore {
    // Single instance of event store
    private static var eventStore: EKEventStore?
    private(set) static var accessGranted: Bool?
    private(set) static var error: Error?
    
    
    static func getInstance() -> EKEventStore {
        if EventStore.eventStore == nil {
            // Initialse single instance
            EventStore.eventStore = EKEventStore()
        }
        // Return the event store instance
        return EventStore.eventStore!
    }
    
    
    static func requestAccess() {
        // Ensure we have an event store instance
        guard eventStore != nil else {
            return
        }
        
        // Request calendar access and notify observers when completed
        EventStore.eventStore!.requestAccess(to: .event, completion: { granted, error in
            self.accessGranted = granted
            self.error = error
            NotificationCenter.default.post(name: .DidRequestEventStoreAccess, object: EventStore.eventStore!)
        })
    }
}
