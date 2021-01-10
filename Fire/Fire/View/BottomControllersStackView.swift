//
//  BottomControllersStackView.swift
//  Fire
//
//  Created by mohamed elgharpawi on 9/8/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit

protocol BottonControllersStackViewDelegate : class{
    func like()
    func disLike()
    func refresh()
}

class BottonControllersStackView: UIStackView {
    
    weak var delegate : BottonControllersStackViewDelegate?
    
    let refreshButton=UIButton(type: .system)
    let dislikeButton=UIButton(type: .system)
    let superlikeButton=UIButton(type: .system)
    let likeButton=UIButton(type: .system)
    let boostButton=UIButton(type: .system)

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        heightAnchor.constraint(equalToConstant: 100).isActive=true
        distribution = .fillEqually

        refreshButton.setImage(#imageLiteral(resourceName: "refresh_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        dislikeButton.setImage(#imageLiteral(resourceName: "dismiss_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        superlikeButton.setImage(#imageLiteral(resourceName: "super_like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        likeButton.setImage(#imageLiteral(resourceName: "like_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        boostButton.setImage(#imageLiteral(resourceName: "boost_circle").withRenderingMode(.alwaysOriginal), for: .normal)
        refreshButton.addTarget(self, action: #selector(handelRefresh), for: .touchUpInside)
        dislikeButton.addTarget(self, action: #selector(handelDislike), for: .touchUpInside)
        likeButton.addTarget(self, action: #selector(handelLike), for: .touchUpInside)

        
        
//        [refreshButton,UIView(),dislikeButton,UIView(),superlikeButton,UIView(),likeButton,UIView(),boostButton]
        [dislikeButton,UIView(),refreshButton,UIView(),likeButton]
            .forEach{
            view in
            addArrangedSubview(view)
            
        }
        
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- Actions
    @objc func handelRefresh(){
        delegate?.refresh()
    }
    @objc func handelDislike(){
        delegate?.disLike()
    }
    @objc func handelLike(){
        delegate?.like()
    }

}
