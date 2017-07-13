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
    
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController){
        print("tabBar -- didelectItem: \((viewController.title)!)")
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        
        print(toVC.title ?? "title")
        let animatedTransitioningObject = BounceTransition()
        return animatedTransitioningObject
    }  

}
