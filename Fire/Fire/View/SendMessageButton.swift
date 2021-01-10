//
//  SendMessageButton.swift
//  Fire
//
//  Created by mohamed elgharpawi on 10/29/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit

class SendMessageButton: UIButton {
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        let gradientLayer = CAGradientLayer()
                let leftColor=#colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
                let rightColor=#colorLiteral(red: 0.4745098054, green: 0.8392156959, blue: 0.9764705896, alpha: 1)
        gradientLayer.colors = [leftColor.cgColor,rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)
        self.layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
        gradientLayer.frame = rect
    }
}
