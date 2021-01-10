//
//  CustomTextField.swift
//  Fire
//
//  Created by mohamed elgharpawi on 9/12/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
     init(placeholder: String,isSecure:Bool = false) {
        super.init(frame: .zero)
        let spacer = UIView()
               spacer.setDimensions(height: 50, width: 12)
             leftView = spacer
            leftViewMode = .always
               borderStyle = .none
            textColor = .white
        keyboardAppearance = .dark
            backgroundColor = UIColor(white: 1, alpha: 0.2)
               heightAnchor.constraint(equalToConstant: 50).isActive = true
            attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor:UIColor(white: 1, alpha: 0.7)])
              layer.cornerRadius=5
        isSecureTextEntry=isSecure
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
