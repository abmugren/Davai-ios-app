//
//  uiviewExten.swift
//  Davai
//
//  Created by Apple on 3/25/19.
//  Copyright © 2019 Moataz Mamdouh. All rights reserved.
//

import Foundation
import UIKit


extension UIButton
{
    func applyGradient(colors: [CGColor])
    {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = colors
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0)
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
    }
}
