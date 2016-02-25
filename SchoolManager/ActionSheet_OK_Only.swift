//
//  ActionSheet_OK_Only.swift
//  SchoolManager
//
//  Created by Peter Sypek on 25.02.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//

import Foundation
import UIKit


class ActionSheet_OK_Only: IAlert{
    private let _presentingView:UIViewController!
    
    init(presentingView:UIViewController){
        self._presentingView = presentingView
    }
    
    func showAlert(title:String, message:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { (UIAlertAction) -> Void in  }))
        
        self._presentingView.presentViewController(alert, animated: true, completion: nil)
    }
}