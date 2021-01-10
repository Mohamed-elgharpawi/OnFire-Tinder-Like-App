//
//  MatchCell.swift
//  Fire
//
//  Created by mohamed elgharpawi on 11/5/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit

class MatchCell: UICollectionViewCell {
    //MARK: - Proprities
    
    var viewModel : MatchCellViewModel! {
        didSet{
            profileImageView.sd_setImage(with: viewModel.imgUrl, completed: nil)
            usernameLabel.text = viewModel.name
        }
    }
    
   private let profileImageView : UIImageView = {
        let iv = UIImageView(image: #imageLiteral(resourceName: "lady4c"))
        iv.contentMode = .scaleAspectFill
        iv.setDimensions(height: 80, width: 80)
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.cornerRadius = 80/2
        
        
        return iv
        
    }()
    
    private let usernameLabel : UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
        label.textColor = .black
        label.textAlignment = .center
        return label
        
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        let stack = UIStackView(arrangedSubviews: [profileImageView,usernameLabel])
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.spacing = 2
        addSubview(stack)
        stack.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    


    
    
}
