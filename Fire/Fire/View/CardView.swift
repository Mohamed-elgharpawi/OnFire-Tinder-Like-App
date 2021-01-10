//
//  CardView.swift
//  Fire
//
//  Created by mohamed elgharpawi on 9/8/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit
import SDWebImage

enum swipeDirection : Int{
    case left = -1
  case right=1
    
}
protocol cardViewDelegate : class {
    func cardView (_ view : CardView , wantsToShowUserProfile user : User)
    func cardView (_ view : CardView , didLikeUser  : Bool)

}

class CardView: UIView {
    weak var delegate:cardViewDelegate?
    let viewModel:CardViewModel
    private let gradientLayer=CAGradientLayer()
    private lazy var barStackView = SegmentBarView(numberOfSegments: viewModel.imageURLs.count)
    private let imageView:UIImageView = {
        
        let iV = UIImageView()
        iV.contentMode = .scaleAspectFill
        return iV
        
        
    }()
    
    private lazy var   infoLabel:UILabel = {
        let lable = UILabel()
        lable.numberOfLines=2
        lable.attributedText=viewModel.userAtributedText
        return lable
        
        
    }()
    
    private lazy var infoButton:UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "info_icon").withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleShowProfile), for: .touchUpInside)
    
        return button
        
    }()
    
    
    
     init(viewModel: CardViewModel) {
        self.viewModel=viewModel
        super.init(frame: .zero)
        backgroundColor = .white
        configureGestureRecognizer()
        //imageView.image=viewModel.user.images.first
        if let urlString = viewModel.imageURLs.first{
           
            guard let url = URL(string: urlString) else{return}
            
            imageView.sd_setImage(with: url)

        }
        layer.cornerRadius=10
        clipsToBounds=true

        addSubview(imageView)
        imageView.fillSuperview()
         configuerBarStckView()
        configurGradientLayer()

        addSubview(infoLabel)
        infoLabel.anchor( left: leftAnchor, bottom: bottomAnchor, right: rightAnchor, paddingLeft: 16, paddingBottom: 16, paddingRight: 16)
        addSubview(infoButton)
        
        infoButton.centerY(inView: infoLabel)
        infoButton.anchor(right:rightAnchor,paddingRight: 16)
        infoButton.setDimensions(height: 40, width: 40)
        
    }
    // To add a frame to applay on it the gradiant
    override func layoutSubviews() {
        gradientLayer.frame=self.frame
    }
    
    
    func configuerBarStckView()  {
        
        addSubview(barStackView)
        barStackView.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 8, paddingLeft: 8,  paddingRight: 8,height: 4)
       
        
    }
    
    func configurGradientLayer() {
        gradientLayer.colors=[UIColor.clear.cgColor,UIColor.black.cgColor]
        gradientLayer.locations=[0.5,1.1]
        layer.addSublayer(gradientLayer)
        
    }
    
    @objc func handelPanGesture(sender:UIPanGestureRecognizer){
        switch sender.state{
        case .began:
            superview?.subviews.forEach({$0.layer.removeAllAnimations()})
        case .ended:
            rsetCardPosition(sender: sender)

        case .changed:
            panCard(sender: sender)
        default:break
        }
        
    }
    
    @objc func handelChangePhoto(sender:UITapGestureRecognizer){
        let location = sender.location(in: nil).x
        let shouldShowNextPhoto=location>self.frame.width/2
        
        if shouldShowNextPhoto {
            viewModel.showNext()
        }
        else{
            viewModel.showPrev()
        }
//        imageView.image=viewModel.imageToShow
        
        imageView.sd_setImage(with: viewModel.imgUrl)
        barStackView.markedSegment(index: viewModel.index)
       
        
    }
    
    @objc func handleShowProfile(){
        delegate?.cardView(self, wantsToShowUserProfile: viewModel.user)
        
    }
    func configureGestureRecognizer() {
        let panGestuer=UIPanGestureRecognizer(target: self, action: #selector(handelPanGesture))
        addGestureRecognizer(panGestuer)
        
        let tapGesture=UITapGestureRecognizer(target: self, action: #selector(handelChangePhoto))
        addGestureRecognizer(tapGesture)

    }
    
    func panCard(sender:UIPanGestureRecognizer) {
        let translation=sender.translation(in: nil)

        let degrees = translation.x / 20
        let angle = degrees * .pi / 180
        let retationalTransform = CGAffineTransform(rotationAngle: angle)
        self.transform = retationalTransform.translatedBy(x: translation.x, y: translation.y)
        
        
    }
    func rsetCardPosition(sender:UIPanGestureRecognizer)  {
        let direction:swipeDirection=sender.translation(in: nil).x>100 ? .right :.left
        let shoudBeDismissed = abs(sender.translation(in: nil).x)>100
        

        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            if shoudBeDismissed {
                let xTranslation = direction.rawValue * 1000
                let awayFromScreenTransform = self.transform.translatedBy(x: CGFloat(xTranslation), y: 0)
                self.transform=awayFromScreenTransform
                
                
                
            }
            else{
                self.transform = .identity

            }}) { (Bool) in
                if shoudBeDismissed {
//                    self.removeFromSuperview()
                    let didLike = direction == .right
                    
                    self.delegate?.cardView(self, didLikeUser:didLike)
                }
            
            
        }

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
