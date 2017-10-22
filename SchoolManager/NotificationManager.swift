
import Foundation
import UIKit
class test {
    
}
/**
 **Notification Manager class**
 The add Observer in NSNotification Center needs to be in the ViewController class
 The selector is the function which gets called when the NotificationCenter sends the message with name:
 
 NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleModifyListNotification:", name: "editNotification", object: nil)
 NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleDeleteListNotification:", name: "deleteNotification", object: nil)
 
 */
class NotificationManager {
    private static var notificationCategory:String = "schoolManagerReminderCategory"
    
    /**
     **Returns a fixed Date from a NSDate object**
     - Parameters:
     - dateToFix: **NSDate:**   The date to be fixed
     - returns: Valid Date of current UICalendar: **NSDate**
     */
    static func fixNotificationDate(dateToFix: NSDate) -> NSDate {
        let calendar = NSCalendar.current
        let dateComponents:NSDateComponents!
        dateComponents = dateComponents.components([NSCalendar.Unit.Year, NSCalendar.Unit.Month, .Day, NSCalendar.Unit.Hour, NSCalendar.Unit.Minute], fromDate: dateToFix)
        dateComponents.second = 0
        let fixedDate: NSDate! = NSCalendar.currentCalendar.dateComponents(dateComponents)
        return fixedDate
    }
    
    /**
     **Creates a local Notification**
     - Parameters:
     - fireDate: **NSDate:**   Date the Notification shows up
     - alertBody: **String:**   Message the Notification shows
     - alertAction: **String:**   Message that is displayed after "side to ..."
     */
    static func createSingleNotification(fireDate:NSDate, alertBody:String, category:String, objectID:String){
        let notification:UILocalNotification = UILocalNotification ()
        notificationCategory = category
        notification.alertBody = alertBody
        notification.fireDate = fireDate as Date
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.category = notificationCategory
        notification.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        let infoDict :  Dictionary<String,String?> = ["objectId" : objectID]
        notification.userInfo = infoDict  ?? "";
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    /**
     **Creates a local Notification**
     - Parameters:
     - fireDate: **NSDate:**   Date the Notification shows up
     - alertBody: **String:**   Message the Notification shows
     - repatInterval: **NSCalendarUnit:**   The repeat intervall for this notification
     - alertAction: **String:**   Message that is displayed after "side to ..."
     */
    static func createRepeatableNotification(fireDate:NSDate, alertBody:String, repatInterval:NSCalendar.Unit, objectID:String){
        let notification:UILocalNotification = UILocalNotification ()
        notification.alertBody = alertBody
        notification.fireDate = fireDate as Date
        notification.soundName = UILocalNotificationDefaultSoundName
        notification.repeatInterval = repatInterval
        notification.category = notificationCategory
        notification.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        let infoDict :  Dictionary<String,String?> = ["objectId" : objectID]
        notification.userInfo = infoDict;
        UIApplication.shared.scheduleLocalNotification(notification)
    }
    
    static func removeNotification(objectID:String){
        for notification in UIApplication.shared.scheduledLocalNotifications! {
            var infoDict :  Dictionary = notification.userInfo as! Dictionary<String,String?>
            let notifcationObjectId : String = infoDict["objectId"]!!
            
            if notifcationObjectId == objectID {
                UIApplication.shared.cancelLocalNotification(notification)
            }
        }
    }    
    
}
