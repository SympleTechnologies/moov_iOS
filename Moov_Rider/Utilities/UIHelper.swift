//
//  UIHelper.swift
//  Moov_Rider
//
//  Created by Taiwo on 13/11/2018.
//  Copyright © 2018 Visakh. All rights reserved.
//

import Foundation

struct UIHelper {
    static func addGradient(view: UIView) {

        let gradientLayer = CAGradientLayer()

        let colorTop = UIColor(red: 1, green: 1, blue: 1, alpha: 1.0)
        let colorBottom = UIColor(red: 247/255, green: 247/255, blue: 250/255, alpha: 1.0)

        gradientLayer.colors = [colorBottom.cgColor, colorTop.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.locations = [0, 1]
        gradientLayer.frame = view.bounds

        view.layer.insertSublayer(gradientLayer, at: 0)
    }
}
