//
//  MatchView.swift
//  Fire
//
//  Created by mohamed elgharpawi on 10/29/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit
protocol MatchViewDelegate {
    func matchView(view:MatchView,wantsToSendMessageTo user :User)
}

class MatchView: UIView {
    //MARK:- Proprities
    var delegate : MatchViewDelegate?
    var viewModel : MatchViewViewModel
    
    private let matchImageView:UIImageView={
        let iv = UIImageView(image: #imageLiteral(resourceName: "itsamatch"))
        iv.contentMode = .scaleAspectFill
        return iv
        
        
    }()
    
    private let descriptionLabel:UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 20)
        lable.textColor = .white
        lable.numberOfLines = 0
        lable.text = " You and Mohamed has liked each other!"
        
        return lable
        
        
    }()
    
    private let currentUserImageView:UIImageView={
        let iv = UIImageView(image: #imageLiteral(resourceName: "kelly3"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
        
    }()
    private let matchedUserImageView:UIImageView={
        let iv = UIImageView(image: #imageLiteral(resourceName: "kelly3"))
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.borderWidth = 2
        iv.layer.borderColor = UIColor.white.cgColor
        return iv
        
    }()
    
    private let sendMessageButton:UIButton={
        let btn = SendMessageButton(type: .system)
        btn.setTitle("Send Message", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(clickSendMessage), for: .touchUpInside)
        return btn
        
    }()
    
    private let keepSwipingButton:UIButton={
        let btn = KeepSwipingButton(type: .system)
        btn.setTitle("Keep Swiping", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(dismiss), for: .touchUpInside)
        return btn
        
    }()
    let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
    
    lazy var views = [
        matchImageView,
        descriptionLabel,
        currentUserImageView,
        matchedUserImageView,
        sendMessageButton,
        keepSwipingButton
        
    
    ]
    
    //MARK:- Lifecycle

    init(viewModel : MatchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        loadUserData()
        configBlurView()
        configUI()
        configAnimation()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK:- Actions
    
    @objc func clickSendMessage(){
        
        delegate?.matchView(view: self, wantsToSendMessageTo: viewModel.matchedUser)
    }
    @objc func dismiss(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut) {
            self.alpha = 0
        } completion: { (_) in
            
            self.removeFromSuperview()
        }

        
    }

    
    
    //MARK:- Helpers
    func loadUserData()  {
        descriptionLabel.text = viewModel.descriptionText
        currentUserImageView.sd_setImage(with: viewModel.currentUserImg, completed: nil)
        matchedUserImageView.sd_setImage(with: viewModel.matchedUserImg, completed: nil)
    }
    
    func configUI() {
        views.forEach { (view) in
            addSubview(view)
            view.alpha=0
        }
        currentUserImageView.anchor(right: centerXAnchor , paddingRight: 16)
        currentUserImageView.setDimensions(height: 140, width: 140)
        currentUserImageView.layer.cornerRadius = 140 / 2
        currentUserImageView.centerY(inView: self)
        
        matchedUserImageView.anchor(left: centerXAnchor , paddingLeft: 16)
        matchedUserImageView.setDimensions(height: 140, width: 140)
        matchedUserImageView.layer.cornerRadius = 140 / 2
        matchedUserImageView.centerY(inView: self)
        
        sendMessageButton.anchor(top: currentUserImageView.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 32, paddingLeft: 48,paddingRight: 48)
        sendMessageButton.heightAnchor.constraint(equalToConstant: 60).isActive=true
   
        keepSwipingButton.anchor(top: sendMessageButton.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 48,paddingRight: 48)
        keepSwipingButton.heightAnchor.constraint(equalToConstant: 60).isActive=true

        descriptionLabel.anchor(left: leftAnchor, bottom: currentUserImageView.topAnchor, right: rightAnchor, paddingBottom: 32)
        matchImageView.anchor(bottom : descriptionLabel.topAnchor, paddingBottom: 16)
        matchImageView.setDimensions(height: 80, width: 300)
        matchImageView.centerX(inView: self)
    
    
    }
    
    
    
    
    
    func configBlurView()  {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismiss))
        visualEffectView.addGestureRecognizer(tapGesture)
        addSubview(visualEffectView)
        visualEffectView.fillSuperview()
        visualEffectView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.visualEffectView.alpha=1
        }, completion: nil)
    }
    
    
    
    func configAnimation(){
        views.forEach({$0.alpha = 1})
        let angle = 30 * CGFloat.pi / 180
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))
        matchedUserImageView.transform = CGAffineTransform(rotationAngle: angle).concatenating(CGAffineTransform(translationX: -200, y: 0))
        self.sendMessageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        self.keepSwipingButton.transform = CGAffineTransform(translationX: 500, y: 0)
        
        UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic, animations: {
           
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -angle)
                self.matchedUserImageView.transform = CGAffineTransform(rotationAngle: -angle)

            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                self.currentUserImageView.transform = .identity
                self.matchedUserImageView.transform = .identity

            }
        }, completion: nil)
        
        UIView.animate(withDuration: 0.75, delay: 0.6 * 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.sendMessageButton.transform = .identity
            self.keepSwipingButton.transform = .identity
        }, completion: nil)
    }


    
}
