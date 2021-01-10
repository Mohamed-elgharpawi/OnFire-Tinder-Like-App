//
//  HomeNavigationStackView.swift
//  Fire
//
//  Created by mohamed elgharpawi on 9/8/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit

protocol  HomeNavigationStackDelegate:class {
   func showMessages()
   func showSettings()
}
class HomeNavigationStackView: UIStackView {
    weak var delegate :HomeNavigationStackDelegate?
    let settingsButton=UIButton(type: .system)
    let fireIcon=UIImageView(image: #imageLiteral(resourceName: "app_icon"))
    let messageButton=UIButton(type: .system)
    override init(frame: CGRect) {
        super.init(frame: frame)
        fireIcon.contentMode = .scaleAspectFit
        heightAnchor.constraint(equalToConstant: 80).isActive=true
        settingsButton.setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)
        messageButton.setImage(#imageLiteral(resourceName: "top_messages_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        [settingsButton,UIView(),fireIcon,UIView(),messageButton].forEach{
            view in
            addArrangedSubview(view)
            
        }
        distribution = .equalCentering
        isLayoutMarginsRelativeArrangement=true
        layoutMargins = .init(top: 0, left: 16, bottom: 0, right: 16)
        
        settingsButton.addTarget(self, action: #selector(handelShowSettings), for: .touchUpInside)
        
        messageButton.addTarget(self, action: #selector(handelShowMessages), for: .touchUpInside)

        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func handelShowSettings(){
        delegate?.showSettings()
        
    }
    @objc func handelShowMessages(){
        delegate?.showMessages()

      }
}
