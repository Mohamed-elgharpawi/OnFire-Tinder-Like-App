//
//  SegmentBarView.swift
//  Fire
//
//  Created by mohamed elgharpawi on 10/26/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit
class SegmentBarView: UIStackView {
    
    
    init(numberOfSegments : Int) {
        super.init(frame: .zero)
        (0..<numberOfSegments).forEach { _ in
            let bar = UIView()
            bar.backgroundColor = .barDeselectedColor
            addArrangedSubview(bar)
        }
     arrangedSubviews.first?.backgroundColor = .white

        spacing = 4
        distribution = .fillEqually
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func markedSegment(index : Int)  {
    arrangedSubviews.forEach { $0.backgroundColor = .barDeselectedColor}
    arrangedSubviews[index].backgroundColor = .white
    }
    
    
}
