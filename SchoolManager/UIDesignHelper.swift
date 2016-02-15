//
//  UIDesignHelper.swift
//  SchoolManager
//
//  Created by Peter Sypek on 04.01.16.
//  Copyright © 2016 Peter Sypek. All rights reserved.
//

import UIKit

class UIDesignHelper {
    static func ShadowMaker(shadowColor:UIColor, shadowOffset:CGFloat, shadowRadius:CGFloat, layer:CALayer){
        layer.shadowColor = shadowColor.CGColor
        layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset/2);
        layer.shadowRadius = shadowRadius;
        layer.shadowOpacity = 1.0;
        layer.masksToBounds = false;
        layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius:  layer.cornerRadius).CGPath
    }
    static func ShadowMakerMultipleLayers(shadowColor:UIColor, shadowOffset:CGFloat, shadowRadius:CGFloat, layers:[CALayer]){
        for layer in layers{
            layer.shadowColor = shadowColor.CGColor
            layer.shadowOffset = CGSizeMake(shadowOffset, shadowOffset/2);
            layer.shadowRadius = shadowRadius;
            layer.shadowOpacity = 1.0;
            layer.masksToBounds = false;
            layer.shadowPath = UIBezierPath(roundedRect: layer.bounds, cornerRadius:  layer.cornerRadius).CGPath
        }
    }
}
