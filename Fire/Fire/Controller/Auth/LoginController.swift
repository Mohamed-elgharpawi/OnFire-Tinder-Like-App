//
//  LoginController.swift
//  Fire
//
//  Created by mohamed elgharpawi on 9/10/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit
import ProgressHUD

protocol AuthDelegate : class {
 func authComplete()
}

class LoginController: UIViewController {
    
    // MARK:- proprities
    weak var delegate : AuthDelegate?
    private var loginViewModel = LoginViewModel()
    private let  iconImage:UIImageView = {
       let imageView = UIImageView()
        imageView.image = #imageLiteral(resourceName: "app_icon").withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .white
        return imageView
        
    }()
    
    let emailTextField = CustomTextField(placeholder: "Email")
    let passwordTextField = CustomTextField(placeholder: "Password",isSecure: true)
    let authButton:AuthButton={
        let btn = AuthButton(type: .system)
        btn.setTitle("Login", for: .normal)
        btn.titleLabel?.font=UIFont.systemFont(ofSize: 16, weight: .heavy)
        btn.addTarget(self, action: #selector(handelLogin), for: .touchUpInside)
        return btn
    }()
    
    let registerationButton:UIButton = {
        
        let btn = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account? ", attributes: [.foregroundColor:UIColor.white
        ])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [.foregroundColor:UIColor.white,.font:UIFont.boldSystemFont(ofSize: 16)]))
        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.addTarget(self, action: #selector(showRegistrationPage), for: .touchUpInside)
        
       
        return btn
        
        
    }()
    
    //MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configuerTextFieldObservers()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    
    
    //MARK: - Helpers

    func configureUI() {
//        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
//            view.addGestureRecognizer(tap)

        configureGradientLayer()
        navigationController?.navigationBar.isHidden=true
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.setDimensions(height: 100, width: 100)
        iconImage.anchor(top: view.safeAreaLayoutGuide.topAnchor,  paddingTop:12)
        let stackView = UIStackView(arrangedSubviews: [emailTextField,passwordTextField,authButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        view.addSubview(stackView)
        stackView.anchor(top: iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32,  paddingRight: 32)
        view.addSubview(registerationButton)
        registerationButton.anchor( left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
    }
    func configuerTextFieldObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)

        passwordTextField.addTarget(self, action: #selector(textDidChanged), for: .editingChanged)
    }
    
    
    func checkFormStatus(){
        if loginViewModel.isValid {
            authButton.isEnabled = true
            authButton.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
        }
        else{
            authButton.isEnabled = false
            authButton.backgroundColor=#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)

        }
    }
   
    //MARK: - Actions
    @objc func textDidChanged(sender:UITextField){
        
        if sender == emailTextField {
            loginViewModel.email = sender.text
        }
        else{
            loginViewModel.password = sender.text
        }
        checkFormStatus()
        
    }

    @objc func handelLogin(){
        guard let email = emailTextField.text else{return}
        guard let password = passwordTextField.text else{return}
        AlertView.showLoader(withMessage: "Logging in ...")

        AuthService.logUserIn(withEmail: email, password: password) { (result, error) in
            
            if let error = error {
                print("Error in user Login \(error.localizedDescription)")
                AlertView.showAlert(controller:self,title: "Alert!", msg:  error.localizedDescription)

                ProgressHUD.dismiss()

                return
            }
            ProgressHUD.dismiss()
            self.delegate?.authComplete()
            
        }

    }
    
    @objc func showRegistrationPage(){
        let controller = RegisterationController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    
}
