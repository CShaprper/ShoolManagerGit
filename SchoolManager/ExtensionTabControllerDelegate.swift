//
//  TabControllerDelegateExtension.swift
//  SchoolManager
//
//  Created by Peter Sypek on 21.12.15.
//  Copyright © 2015 Peter Sypek. All rights reserved.
//

import Foundation
import UIKit

extension AppDelegate:UITabBarControllerDelegate{
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController){
        print("tabBar -- didelectItem: \((viewController.title)!)")
    }
    
    func tabBarController(tabBarController: UITabBarController, animationControllerForTransitionFromViewController fromVC: UIViewController, toViewController toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        print(toVC.title)
        let animatedTransitioningObject = BounceTransition()
        return animatedTransitioningObject
    }  

}
