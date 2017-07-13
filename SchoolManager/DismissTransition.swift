//
//  DismissTransition.swift
//  SchoolManager
//
//  Created by Peter Sypek on 22.12.15.
//  Copyright © 2015 Peter Sypek. All rights reserved.
//

import UIKit

class DismissTransition: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate{
    
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        let fromViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)!
        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)!
        let finalFrameForVC = transitionContext.finalFrame(for: toViewController)
        let containerView = transitionContext.containerView
        toViewController.view.frame = finalFrameForVC
        toViewController.view.alpha = 0.5
        containerView.addSubview(toViewController.view)
        containerView.sendSubview(toBack: toViewController.view)
        
        let snapshotView = fromViewController.view.snapshotView(afterScreenUpdates: false)
        snapshotView?.frame = fromViewController.view.frame
        containerView.addSubview(snapshotView!)
        
        fromViewController.view.removeFromSuperview()
        
        UIView.animate(withDuration: transitionDuration(using: transitionContext), animations: {
            snapshotView?.frame = fromViewController.view.frame.insetBy(dx: fromViewController.view.frame.size.width / 2, dy: fromViewController.view.frame.size.height / 2)
            toViewController.view.alpha = 1.0
            }, completion: {
                finished in
                snapshotView?.removeFromSuperview()
                transitionContext.completeTransition(true)
        })  
    }
    
    
    // return how many seconds the transiton animation will take
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 1.0   }
    
    // MARK: UIViewControllerTransitioningDelegate protocol methods
    
    // return the animataor when presenting a viewcontroller
    // remmeber that an animator (or animation controller) is any object that aheres to the UIViewControllerAnimatedTransitioning protocol
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? { 
        return self
    }
}
