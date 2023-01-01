//
//  GradientForView.swift
//  ExchCurrency
//
//  Created by Dana on 20/11/2022.
//  Copyright © 2022 Sito. All rights reserved.
//

import UIKit

extension CAGradientLayer {
    convenience init(start:  CAGradientPoint, end: CAGradientPoint, colors: [CGColor], type: CAGradientLayerType, locationsArray: [NSNumber]) {
        self.init()
        self.frame.origin = CGPoint.zero
        self.startPoint = start.point
        self.endPoint = end.point
        self.colors = colors
        self.type = type
        self.locations = locationsArray
    }
}

extension UIView {
    
    func layerGradient(startPoint:CAGradientPoint, endPoint:CAGradientPoint ,colorArray:[CGColor], type:CAGradientLayerType, locations: [NSNumber]) {
        let gradient = CAGradientLayer(start: startPoint, end: endPoint, colors: colorArray, type: type, locationsArray: locations)
        gradient.frame.size = self.frame.size
        self.layer.insertSublayer(gradient, at: 0)
    }
}
