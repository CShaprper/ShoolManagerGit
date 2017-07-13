//
//  BackTransitionManager.swift
//  SchoolManager
//
//  Created by Peter Sypek on 12.12.15.
//  Copyright © 2015 Peter Sypek. All rights reserved.
//

import UIKit

class WipeTransition: NSObject, UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate {
    
    private var presenting = true
    
    // MARK: UIViewControllerAnimatedTransitioning protocol methods
    
    // animate a change from one viewcontroller to another
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        
        // get reference to our fromView, toView and the container view that we should perform the transition in
        let container = transitionContext.containerView
        let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from)!
        let toView = transitionContext.view(forKey: UITransitionContextViewKey.to)!
        
        // set up from 2D transforms that we'll use in the animation
        let π : CGFloat = 3.14159265359
        
        let offScreenRight = CGAffineTransform(rotationAngle: -π/2)
        let offScreenLeft = CGAffineTransform(rotationAngle: π/2)
        
        // prepare the toView for the animation
        toView.transform = self.presenting ? offScreenRight : offScreenLeft
        
        // set the anchor point so that rotations happen from the top-left corner
        toView.layer.anchorPoint = CGPoint(x:0, y:0)
        fromView.layer.anchorPoint = CGPoint(x:0, y:0)
        
        // updating the anchor point also moves the position to we have to move the center position to the top-left to compensate
        toView.layer.position = CGPoint(x:0, y:0)
        fromView.layer.position = CGPoint(x:0, y:0)
        
        // add the both views to our view controller
        container.addSubview(toView)
        container.addSubview(fromView)
        
        // get the duration of the animation
        // DON'T just type '0.5s' -- the reason why won't make sense until the next post
        // but for now it's important to just follow this approach
        let duration = self.transitionDuration(using: transitionContext)
        
        // perform the animation!
        // for this example, just slid both fromView and toView to the left at the same time
        // meaning fromView is pushed off the screen and toView slides into view
        // we also use the block animation usingSpringWithDamping for a little bounce
        UIView.animate(withDuration: duration, delay: 0.0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.8, options: [], animations: {
            
            // slide fromView off either the left or right edge of the screen
            // depending if we're presenting or dismissing this view
            fromView.transform = self.presenting ? offScreenLeft : offScreenRight
            toView.transform = CGAffineTransformIdentity
            
            }, completion: { finished in
                // tell our transitionContext object that we've finished animating
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
        // these methods are the perfect place to set our `presenting` flag to either true or false - voila!
        self.presenting = true
        return self
    }
    
    // return the animator used when dismissing from a viewcontroller
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        self.presenting = false
        return self
    }  
    
}

