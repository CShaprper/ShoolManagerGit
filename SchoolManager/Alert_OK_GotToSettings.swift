//
//  Alert_OK_GotToSettings.swift
//  SchoolManager
//
//  Created by Peter Sypek on 25.02.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//

import Foundation
import UIKit

class Alert_OK_GoToSettings: IAlert_OneAction{
    private let _presentingView:UIViewController!
    
    init(presentingView:UIViewController){
        self._presentingView = presentingView
    }
    
    func showAlert_OneAction(title:String, message:String, actionTitle:String){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (UIAlertAction) -> Void in  }))
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (UIAlertAction) -> Void in
            alert.dismiss(animated: true, completion: nil)
            
            let url: NSURL? = NSURL(string: UIApplicationOpenSettingsURLString)
            if url != nil{
                UIApplication.shared.openURL(url! as URL)
            }
            
        }))
        
        self._presentingView.present(alert, animated: true, completion: nil)
    }
}
