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

class AccessGrantedTest: XCTestCase {
    // An expectation that we are granted calendar access
    let expectation = XCTestExpectation(description: "Get permission for calendar access")
    

    // A method that fulfills our expectation if calendar access is granted
    func waitForEventStoreAccess() {
        if EventStore.accessGranted! {
            expectation.fulfill()
        } else {
            XCTFail()
        }
    }

    
    // A test that checks we have been granted calendar access
    func testAccessGranted() throws {
        // Get the event store
        let eventStore = EventStore.getInstance()
        
        // Request to be notified when access is granted (or denied)
        NotificationCenter.default.addObserver(self, selector: #selector(AccessGrantedTest.waitForEventStoreAccess), name: .DidRequestEventStoreAccess, object: eventStore )
        
        // Request calendar access
        EventStore.requestAccess()
        
        // Wait for our expected access to be granted
        wait(for: [expectation], timeout: 10.0)
        
        // At this point the user should have allowed us calendar access
        if !EventStore.accessGranted! {
            XCTFail()
            return
        }
    }
}
