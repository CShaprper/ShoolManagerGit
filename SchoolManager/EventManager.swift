//
//  EventManager.swift
//  SchoolManager
//
//  Created by Peter Sypek on 07.01.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//
import UIKit
import Foundation
import EventKit

class EventManager {
    /*MARK: Member / Outlets
    ###############################################################################################################*/
  static let eventStore = EKEventStore()
    var savedIventIdentifier:String!
    
    
    static func requestAuthorization()->Bool{
        if(EKEventStore.authorizationStatus(for: .event) != EKAuthorizationStatus.authorized){
            eventStore.requestAccess(to: .event, completion: { granted, Error in })
            return false
        }else{ return true }
    }
    
   static func createEvent(eventStore: EKEventStore, title: String, startDate:NSDate, endDate:NSDate, identifier:String){
        let event = EKEvent(eventStore: eventStore)
        event.title = title
        event.startDate = startDate as Date
        event.endDate = endDate as Date
        event.calendar = eventStore.defaultCalendarForNewEvents
        do{
            try eventStore.save(event, span: .thisEvent)
//            savedIventIdentifier = event.eventIdentifier
        }catch let error as NSError{ print(error) }
    }
   static func removeEvent(eventStore:EKEventStore, eventIdentifier:String){
        let eventToRemove = eventStore.event(withIdentifier: eventIdentifier)
        if eventToRemove != nil{
            do{
                try eventStore.remove(eventToRemove!, span: .thisEvent)
            }catch let error as NSError{
                print(error)
            }
        }
    }   
}
