//
//  ActivityIndicatorAnimation.swift
//  SchoolManager
//
//  Created by Peter Sypek on 25.02.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//
import UIKit
import Foundation

class ActivityIndicatorAnimation : IAnimation {
    private let _presentingView:UIViewController!
    private let _indicatorView:UIActivityIndicatorView!
    
    init(presentingView:UIViewController){
        self._presentingView = presentingView
        self._indicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        self._indicatorView.center = CGPoint(x: self._presentingView.view.bounds.width / 2, y: self._presentingView.view.bounds.height / 2)
        self._presentingView.view.addSubview(self._indicatorView)
    }
    
    func beginAnimation() {
        self._indicatorView.isHidden = false
        self._indicatorView.startAnimating()
    }
    
    func endAnimation() {
        self._indicatorView.isHidden = true
        self._indicatorView.stopAnimating()
    }
}
