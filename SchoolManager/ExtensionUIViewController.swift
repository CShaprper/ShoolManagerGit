
import UIKit

///Enables popupview for IPhone
extension UIViewController:UIPopoverControllerDelegate{ 
    func adaptivePresentationStyleForPresentationController(controller:UIPopoverPresentationController)->UIModalPresentationStyle{
        return .none
    }
}

extension UIView {
    func fadeIn(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping ((Bool) -> Void) = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 1.0
            }, completion: completion)  }
    
    func fadeOut(duration: TimeInterval = 1.0, delay: TimeInterval = 0.0, completion: @escaping (Bool) -> Void = {(finished: Bool) -> Void in}) {
        UIView.animate(withDuration: duration, delay: delay, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.alpha = 0.0
            }, completion: completion)
    }
}

extension UITabBarController {
    public override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        if let selected = selectedViewController {
            return selected.supportedInterfaceOrientations
        }
        return super.supportedInterfaceOrientations
    }
    public override func shouldAutorotate() -> Bool {
        if let selected = selectedViewController {
            return selected.shouldAutorotate
        }
        return super.shouldAutorotate
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
        return NSNumber(value: num)
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
        dateComponents.hour = NSCalendar.current.components(NSCalendar.Unit.Hour, fromDate: date).hour
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
        dateComponents.minute = NSCalendar.current.components(NSCalendar.Unit.Minute, fromDate: date).minute
        return dateComponents.minute
    }
    
}
