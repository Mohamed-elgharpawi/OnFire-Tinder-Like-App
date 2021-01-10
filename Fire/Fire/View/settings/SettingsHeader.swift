//
//  SettingHeader.swift
//  Fire
//
//  Created by mohamed elgharpawi on 9/21/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//


import UIKit
import SDWebImage

protocol SettingsHeaderDelegate : class {
    func settingsHeader(_ header : SettingsHeader , selectedIndex index :Int)
}
class SettingsHeader: UIView {
    //MARK: -Properity
    let user:User
    weak var  settingsDelegate:SettingsHeaderDelegate?
    
    var buttons = [UIButton]()
  
    
    // MARK: -Lifecycle
     init(user: User) {
        self.user = user
        super.init(frame: .zero)
         let button1 = createButton(0)
         let button2 = createButton(1)
         let button3 = createButton(2)
        buttons.append(button1)
        buttons.append(button2)
        buttons.append(button3)
        backgroundColor = .systemGroupedBackground
        addSubview(button1)
        button1.anchor(top: topAnchor, left: leftAnchor, bottom: bottomAnchor, paddingTop:16, paddingLeft: 16, paddingBottom: 15)
        button1.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.45).isActive = true
        let stackView = UIStackView(arrangedSubviews: [button2,button3])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 16
        addSubview(stackView)
        stackView.anchor(top: topAnchor, left: button1.rightAnchor, bottom: bottomAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16,paddingBottom: 16, paddingRight: 16)
        
        loadUserPhotoes()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: -Actions
    @objc func handleSelectPhoto(sender : UIButton){
        settingsDelegate?.settingsHeader(self, selectedIndex: sender.tag)
        
    }

    // MARK: -Helpers
    func loadUserPhotoes()  {
        
        var imageURLs = user.imageURLs.map({URL(string: $0)})
        imageURLs.reverse()
        
        for(index,url) in imageURLs.enumerated(){
            if(index<3){
                self.buttons[index].setTitle("", for: .normal)
                self.buttons[index].setImage(#imageLiteral(resourceName: "top_left_profile").withRenderingMode(.alwaysOriginal), for: .normal)

            }
        
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                if index < 3{
                    
                    self.buttons[index].setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
                }
            }
            
        }
        
        
        
    }

    func createButton(_ index : Int) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.clipsToBounds = true
        button.backgroundColor = .white
        button.layer.cornerRadius = 10
        button.imageView?.contentMode = .scaleAspectFill
        button.tag = index
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
    }
    
    
    
}
