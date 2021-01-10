//
//  ConversationCell.swift
//  Fire
//
//  Created by mohamed elgharpawi on 11/7/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit
class ConversationCell :  UITableViewCell {
    //MARK: - Proprities
    var conversation : Conversation? {
        didSet{
            config()
        }
    }
    private let profileImageView : UIImageView = {
         let iv = UIImageView()
         iv.contentMode = .scaleAspectFill
         iv.clipsToBounds = true
         iv.backgroundColor = .darkGray
                  
         
         return iv
     }()
    
    private let timestampLabel : UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 12)
        label.text = "2h"
        return label
        
    }()
    private let usernameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
        
    }()
    private let messageLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
        
    }()
    
    //MARK: - Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        profileImageView.anchor( left: leftAnchor,  paddingLeft: 12)
        profileImageView.setDimensions(height: 50, width: 50)
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerY(inView: self)
        let stack = UIStackView(arrangedSubviews: [usernameLabel,messageLabel])
        stack.axis = .vertical
        stack.spacing = 4
        addSubview(stack)
        stack.centerY(inView: profileImageView)
        stack.anchor( left: profileImageView.rightAnchor ,right: rightAnchor, paddingLeft: 12,paddingRight: 16)
        addSubview(timestampLabel)
        timestampLabel.anchor(top: topAnchor, right: rightAnchor, paddingTop: 20,  paddingRight: 12)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: - Helpers
    func config() {
        
        guard let conversation = conversation else { return }
        let viewModel = ConversationViewModel(conversation: conversation)
        usernameLabel.text = conversation.user.name
        messageLabel.text = conversation.message.text
        
        timestampLabel.text = viewModel.timestame
        profileImageView.sd_setImage(with: URL(string: viewModel.profileImage), completed: nil)
        
        
        
    }


    
    
}
