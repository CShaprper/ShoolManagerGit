
import UIKit

///Enables popupview for IPhone
extension UIViewController:UIPopoverControllerDelegate{ 
    func adaptivePresentationStyleForPresentationController(controller:UIPopoverPresentationController)->UIModalPresentationStyle{
        return .None
    }
}

extension UIView {
    func fadeIn(duration: NSTimeInterval = 1.0, delay: NSTimeInterval = 0.0, completion: ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: completion)  }
    
    func fadeOut(duration: NSTimeInterval = 1.0, delay: NSTimeInterval = 0.0, completion: (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animateWithDuration(duration, delay: delay, options: UIViewAnimationOptions.CurveEaseIn, animations: {
            self.alpha = 0.0
            }, completion: completion)
    }
}

extension UITabBarController {
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if let selected = selectedViewController {
            return selected.supportedInterfaceOrientations()
        }
        return super.supportedInterfaceOrientations()
    }
    public override func shouldAutorotate() -> Bool {
        if let selected = selectedViewController {
            return selected.shouldAutorotate()
        }
        return super.shouldAutorotate()
    }
}

extension UIViewController{
    /** 
     **Casts a string number value to an NSNumber**
     - Parameters:
        - strNumber: String:   **The string holding a number**
     - returns: optional: **NSNumber**    
     */
    func CastStringToNSNumber(strNumber:String)->NSNumber?{
        //So lets cast the string value of SelectedHoursPicker to NSNumber
        if let num:Int = Int(strNumber)!{
        return NSNumber(integer: num)
        }else{
            return nil
        } 
    }
    /**
     **Gets the Hour of an NSDate object as Integer value**
     - Parameters:
        - date: **NSDate:**   The date to get the hour from
     - returns: Int: **Hour** as integer from 1 to 24
     */
    func GetTimeAsHour(date:NSDate)->Int{
        let dateComponents = NSDateComponents()
        dateComponents.hour = NSCalendar.currentCalendar().components(NSCalendarUnit.Hour, fromDate: date).hour
        return dateComponents.hour
    }
    /**
     **Gets the Minute of an NSDate object as Integer value**
     - Parameters:
        - date: **NSDate:**   The date to get the hour from
     - returns: Int: **Minute** as integer from 1 to 60
     */
    func GetTimeAsMinute(date:NSDate)->Int{
        let dateComponents = NSDateComponents()
        dateComponents.minute = NSCalendar.currentCalendar().components(NSCalendarUnit.Minute, fromDate: date).minute
        return dateComponents.minute
    }
    
}