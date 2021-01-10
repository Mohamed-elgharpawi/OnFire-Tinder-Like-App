//
//  MessageCell.swift
//  Fire
//
//  Created by mohamed elgharpawi on 11/6/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit

class MessageCell: UICollectionViewCell{
    var message : Message?{
        didSet{
            configureUI()
        }
        
    }
    
    //MARK:-Proprities
    var bubbleLeftAnchor : NSLayoutConstraint!
    var bubbleRightAnchor : NSLayoutConstraint!

    
    private let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    private let textView : UITextView = {
        let tv = UITextView()
        
        tv.backgroundColor = .clear
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isEditable = false
        tv.isScrollEnabled = false
        return tv
        
        
    }()
  private  let bubbleContainer : UIView = {
        let bV = UIView()
    bV.backgroundColor = .blue
       return bV
       
        
    }()
    
    
    //MARK:-Lifecycle
    override init(frame :CGRect){
        super.init(frame: frame)
        addSubview(profileImageView)
        profileImageView.anchor( left: leftAnchor,bottom: bottomAnchor,  paddingLeft: 8, paddingBottom: 4)
        profileImageView.setDimensions(height: 32, width: 32)
        profileImageView.layer.cornerRadius = 32/2
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        bubbleContainer.anchor(top: topAnchor,bottom: bottomAnchor)
        bubbleLeftAnchor =  bubbleContainer.leftAnchor.constraint(equalTo: profileImageView.rightAnchor , constant: 12)
        bubbleLeftAnchor.isActive = true
        bubbleRightAnchor =  bubbleContainer.rightAnchor.constraint(equalTo:rightAnchor , constant: -12)
        bubbleLeftAnchor.isActive = false
        
        
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        bubbleContainer.addSubview(textView)
        textView.anchor(top: bubbleContainer.topAnchor, left: bubbleContainer.leftAnchor, bottom: bubbleContainer.bottomAnchor, right: bubbleContainer.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 4, paddingRight: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helper
    
    func configureUI(){
        guard let message = message else{return}
        let viewModel = MessageViewModel(message: message)
        bubbleContainer.backgroundColor = viewModel.messageBackgroundColor
        textView.textColor = viewModel.textColor
        textView.text = message.text
        bubbleRightAnchor.isActive = viewModel.rightAnchorIsActive
        bubbleLeftAnchor.isActive = viewModel.leftAnchorIsActive
        profileImageView.isHidden = viewModel.shouldHideProfileImage
        profileImageView.sd_setImage(with: URL(string: viewModel.profileImage), completed: nil)
        
        
        
    }

}
