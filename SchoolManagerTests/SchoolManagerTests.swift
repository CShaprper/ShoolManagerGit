import XCTest
import UIKit
import CoreData
@testable import SchoolManager

class SchoolManagerTests: XCTestCase {
    var viewController: MainVC!
    
    override func setUp() {
        super.setUp()
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testHoursPerDayShowsCorrectValue(){
        let t = TimelineManager()
        t.SetHoursPerDay(1)
        XCTAssertEqual(1, t.GetHoursPerDay(), "HoursPerDay should be equal to 1")
    }
    
//    func testHoursPerDayUIViewShowsCorrectValue(){
//        let t = TimelineManager()
//        t.SetHoursPerDay(1)
//        XCTAssertTrue(t.GetHoursPerDayUIValueAsString().containsString("1"), "HoursPerDay should contain 1")
//    }
//    
//    func testThatHoursPerDayArrayIsNotNil(){
//        let t = TimelineManager()
//        t.SetHoursPerDay(1)
//        XCTAssertNotNil(t.HoursPerDayArray, "HoursPerDayArray should not be nil")
//    }
//    
//    func testThatHoursPerDayContainsOneElement(){
//        let t = TimelineManager()
//        t.SetHoursPerDay(1)
//        XCTAssertTrue(t.HoursPerDayArray.count == 1, "HoursPerDayArray should countain 1 element when HoursPerDay property is set to 1")
//    }
//    
//    func testThatHoursPerDayContainsTwoElements(){
//        let t = TimelineManager()
//        t.SetHoursPerDay(2)
//        XCTAssertTrue(t.HoursPerDayArray.count == 2, "HoursPerDayArray should countain 2 elements when HoursPerDay property is set to 2")    }
//    
//    func testThatHoursPerDayContainsCorrectElementCount(){
//        let t = TimelineManager()
//        t.SetHoursPerDay(14)
//        XCTAssertTrue(t.HoursPerDayArray.count == 14, "HoursPerDayArray should countain 14 elements when HoursPerDay property is set to 14")
//    }
//    
//    func testThatGetHoursPerDayAsStringReturnsCorrectString(){
//        let t = TimelineManager()
//        t.SetHoursPerDay(14)
//        XCTAssertTrue(t.GetHoursPerDayAsString() == "14", "HoursPerDayAsString should return 14 as String when HoursPerDay property is set to 14")
//    }
    
    
}
