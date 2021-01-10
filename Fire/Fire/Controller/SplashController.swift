//
//  SplashController.swift
//  Fire
//
//  Created by mohamed elgharpawi on 11/9/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit


class SplashController : UIViewController {
   //MARK:- Proprities
    
    private let  iconImage:UIImageView = {
       let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        return imageView
        
    }()
    private let onLabel:UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.font = UIFont.systemFont(ofSize: 40)
        lable.textColor = .white
        lable.numberOfLines = 0
        lable.text = "On"
        
        return lable
        
        
    }()
    private let appNameLabel:UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.font = UIFont.monospacedSystemFont(ofSize: 50, weight: .heavy)
        lable.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        lable.numberOfLines = 0
        lable.text = "Fire"
        
        return lable
        
        
    }()
    
    private let developerLabel:UILabel = {
        let lable = UILabel()
        lable.textAlignment = .center
        lable.font = UIFont.monospacedDigitSystemFont(ofSize: 20, weight: .bold)
        lable.textColor = .black
        lable.numberOfLines = 0
        lable.text = "© elgharpawi"
        
        return lable
        
        
    }()
    
    //MARK:- Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configAnimation()
        
    }
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    //MARK:- Helpers

    
    func configUI() {
        configureGradientLayer()
        navigationController?.navigationBar.isHidden=true
        view.addSubview(iconImage)
         iconImage.setDimensions(height: 140, width: 140)
         view.addSubview(appNameLabel)
        view.addSubview(onLabel)

        
        let stack = UIStackView(arrangedSubviews: [iconImage,onLabel,appNameLabel])
        stack.axis = .vertical
        stack.spacing = 10
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.centerX(inView: view)

        view.addSubview(developerLabel)
        developerLabel.centerX(inView: view)
        developerLabel.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 20, paddingBottom: 30 , paddingRight: 20)
        
       
    }
    func configAnimation()  {
        iconImage.alpha = 1
        onLabel.alpha = 1
        appNameLabel.alpha = 1
        
        let angle = 30 * CGFloat.pi / 180
        iconImage.transform = CGAffineTransform(rotationAngle: -angle).concatenating(CGAffineTransform(translationX: 200, y: 0))

      self.appNameLabel.transform = CGAffineTransform(translationX: -500, y: 0)
      self.onLabel.transform = CGAffineTransform(translationX: 500, y: 0)
        
        UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic, animations: {
           
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45) {
                self.iconImage.transform = CGAffineTransform(rotationAngle: -angle)

            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
                self.iconImage.transform = .identity

            }
        }, completion: nil)
        
        UIView.animate(withDuration: 2, delay: 1 * 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseInOut, animations: {
            self.iconImage.transform = .identity
            self.appNameLabel.transform = .identity
            self.onLabel.transform = .identity

        }) { (_) in
            

            let controller = HomeController()
            controller.modalTransitionStyle = .flipHorizontal
            controller.modalPresentationStyle = .fullScreen
            self.present(controller, animated: true ,completion: nil)

        }
    }
    
   
    }


    
    

    
    
    
    

