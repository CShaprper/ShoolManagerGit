
import UIKit

class ColorHelper{
    // convert Hex string '#FF00FF' or 'FF00FF' to UIColor object
    static func convertHexToUIColor(hexColor hexColor : String) -> UIColor {
        
        // define character set (include whitespace, newline character etc.)
        let characterSet = NSCharacterSet.whitespaceAndNewlineCharacterSet() as NSCharacterSet
        
        //trim unnecessary character set from string
        var colorString : String = hexColor.stringByTrimmingCharactersInSet(characterSet)
        
        // convert to uppercase
        colorString = colorString.uppercaseString
        
        //if # found at start then remove it.
        if colorString.hasPrefix("#") {
            colorString =  colorString.substringFromIndex(colorString.startIndex.advancedBy(1))
        }
        
        // hex color must 6 chars. if invalid character count then return black color.
        if colorString.characters.count != 6 {
            return UIColor.blackColor()
        }
        
        // split R,G,B component
        var rgbValue: UInt32 = 0
        NSScanner(string:colorString).scanHexInt(&rgbValue)
        let valueRed    = CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0
        let valueGreen  = CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0
        let valueBlue   = CGFloat(rgbValue & 0x0000FF) / 255.0
        let valueAlpha  = CGFloat(1.0)
        
        // return UIColor
        return UIColor(red: valueRed, green: valueGreen, blue: valueBlue, alpha: valueAlpha)
    }

}