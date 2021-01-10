//
//  ProfileCell.swift
//  Fire
//
//  Created by mohamed elgharpawi on 10/25/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit

class ProfileCell: UICollectionViewCell {
    
    //MARK:- Proprities
    let imageView = UIImageView()
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView.contentMode = .scaleAspectFill
        imageView.image = #imageLiteral(resourceName: "jane1")
        addSubview(imageView)
        imageView.fillSuperview()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
