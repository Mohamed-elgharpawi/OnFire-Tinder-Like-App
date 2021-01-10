//
//  AuthButton.swift
//  Fire
//
//  Created by mohamed elgharpawi on 9/12/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit
class AuthButton: UIButton {
    
   override init(frame : CGRect) {
        super.init(frame: frame)
    
        backgroundColor=#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        layer.cornerRadius=5
        heightAnchor.constraint(equalToConstant: 50).isActive=true
        isEnabled=false
        setTitleColor(.white, for: .normal)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
