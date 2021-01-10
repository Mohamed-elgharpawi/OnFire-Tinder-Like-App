//
//  RegisterationController.swift
//  Fire
//
//  Created by mohamed elgharpawi on 9/10/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit
import ProgressHUD
class RegisterationController: UIViewController {
  // MARK:- propreties
    weak var delegate : AuthDelegate?
    var viewModel=RegistrationViewModel()
    let selectPhotoButton:UIButton={
        let btn = UIButton(type: .system)
        btn.tintColor = .white
        btn.setImage(#imageLiteral(resourceName: "plus_photo"), for: .normal)
        btn.clipsToBounds=true
        btn.addTarget(self, action: #selector(handelSelectPhoto), for: .touchUpInside)
        return btn
        
    }()
    
    let emailTextField = CustomTextField(placeholder: "Email")
    let fullNameTextField = CustomTextField(placeholder: "Full Name")
    let passwordTextField = CustomTextField(placeholder: "Password",isSecure: true)
    let authButton:AuthButton={
        let btn = AuthButton(type: .system)
        btn.setTitle("Sign Up", for: .normal)
        btn.titleLabel?.font=UIFont.systemFont(ofSize: 16, weight: .heavy)
        btn.addTarget(self, action: #selector(handelRegister), for: .touchUpInside)
           return btn
       }()
    let goToLoginButton:UIButton = {
        
        let btn = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Already have an account? ", attributes: [.foregroundColor:UIColor.white
        ])
        attributedTitle.append(NSAttributedString(string: "Sign In", attributes: [.foregroundColor:UIColor.white,.font:UIFont.boldSystemFont(ofSize: 16)]))
        btn.setAttributedTitle(attributedTitle, for: .normal)
        btn.addTarget(self, action: #selector(handelShowLogin), for: .touchUpInside)
        
       
        return btn
        
        
    }()
    
   private var profileImage:UIImage?
    
    
    // MARK:- lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configuerUI()
        configuerTextFieldObservers()
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .portrait
    }
    // MARK:- helpers

    func configuerUI()  {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
            view.addGestureRecognizer(tap)
        configureGradientLayer()
        view.addSubview(selectPhotoButton)
        selectPhotoButton.setDimensions(height: 275, width: 275)
        selectPhotoButton.centerX(inView: view)
        selectPhotoButton.anchor(top: view.safeAreaLayoutGuide.topAnchor,  paddingTop: 8)
        let stackView=UIStackView(arrangedSubviews: [emailTextField,fullNameTextField,passwordTextField,authButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        view.addSubview(stackView)
        stackView.anchor(top: selectPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 24, paddingLeft: 32, paddingRight: 32)
        view.addSubview(goToLoginButton)
        goToLoginButton.anchor(left: view.leftAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingLeft: 32, paddingRight: 32)
        
    }
    
    func configuerTextFieldObservers() {
        emailTextField.addTarget(self, action: #selector(didTextChanged), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(didTextChanged), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(didTextChanged), for: .editingChanged)

    }
    
      func checkFormStatus(){
          if viewModel.isValid {
              authButton.isEnabled = true
              authButton.backgroundColor = #colorLiteral(red: 0.1764705926, green: 0.4980392158, blue: 0.7568627596, alpha: 1)
          }
          else{
              authButton.isEnabled = false
              authButton.backgroundColor=#colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)

          }
    }
    
    // MARK:- actions
    @objc func didTextChanged(sender : UITextField){
        if sender == emailTextField {
            viewModel.email = sender.text
        }
        else if sender == fullNameTextField {
            viewModel.fullName = sender.text

        }
        else{
            viewModel.password = sender.text
        }
         checkFormStatus()
    }
    @objc func handelRegister(){
        
        guard let email = emailTextField.text else {return}
        guard let fullname = fullNameTextField.text else { return }
        guard let password = passwordTextField.text else {return}
        guard let image = self.profileImage else {return}
        
        AlertView.showLoader(withMessage: "Signing Up ...")
        AuthService.registerUser(withCredentials: AuthCredentials(email: email,fullname: fullname,password: password,image: image)) { (error) in
            if let error = error {
                print("Sigin user Up error\(error.localizedDescription)")
                AlertView.showAlert(controller:self, title: "Alert!", msg: error.localizedDescription)

                ProgressHUD.dismiss()
                return
            }
            ProgressHUD.dismiss()
            self.delegate?.authComplete()
        }
        
    }
    @objc func handelSelectPhoto(){
        let picker = UIImagePickerController()
        picker.delegate = self
present(picker, animated: true, completion: nil)
        
    }
    
    @objc func handelShowLogin(){
        navigationController?.popViewController(animated: true)
    }
}
// MARK:- UIImagePickerControllerDelegate
extension RegisterationController : UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as! UIImage
        profileImage = image
        selectPhotoButton.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        selectPhotoButton.layer.borderColor=UIColor(white: 1, alpha: 0.7).cgColor
        selectPhotoButton.layer.borderWidth=3
        selectPhotoButton.layer.cornerRadius=10
        selectPhotoButton.clipsToBounds=true
        selectPhotoButton.imageView?.contentMode = .scaleAspectFill
        dismiss(animated: true, completion: nil)
    }
    
   



}
