//
//  SettingsController.swift
//  Fire
//
//  Created by mohamed elgharpawi on 9/18/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

protocol SettingControllerDelegate: class {
    func settingsController ( _ controller : SettingsController, wantsToUpdate user : User)
    func settingsControllerWantsToLogout( _ controller : SettingsController)

}


import UIKit
import ProgressHUD
import Firebase
private let  reuseIdentifier = "SettingsCell"

class SettingsController: UITableViewController {
    
    // MARK: - Proprities
    private  var user:User
    private lazy var headerView = SettingsHeader(user: user)
    private let footerView = SettingsFooter()
     private let imagePicker = UIImagePickerController()
     private var imageIndex = 0
     weak var delegate:SettingControllerDelegate?
    
    // MARK: - Lifecycle
    init(user:User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Actions
    @objc func handleCancel (){
        self.dismiss(animated: true, completion: nil)
        
    }
    @objc func handleDone(){
        view.endEditing(true)

        AlertView.showLoader(withMessage: "Save Changes ...")
        
        Service.saveUserData(user:user) { (error) in
            ProgressHUD.dismiss()
            self.delegate?.settingsController(self, wantsToUpdate: self.user)

        }
        
    }
    
    // MARK: - API
    func uploadImage(image:UIImage)  {
       
        AlertView.showLoader(withMessage: "Uploading image..")
        Service.uploadImage(image: image) { (imageURL, error) in
            if let error = error {
                ProgressHUD.dismiss()
                AlertView.showAlert(controller:self,title: "Alert!", msg:  error.localizedDescription)
                  return
                
            }
            self.user.imageURLs.append(imageURL!)
            
            
            ProgressHUD.dismiss()

            //self.headerView.loadUserPhotoes()
        }
        



    }


    // MARK: - Helpers
    func setHeaderImage(_ image :UIImage) {
        
        headerView.buttons[imageIndex].setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
    }

    
    func configureUI() {
        headerView.settingsDelegate=self
        imagePicker.delegate=self
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        tableView.separatorStyle = .none
        tableView.tableHeaderView = headerView
        tableView.backgroundColor = .systemGroupedBackground
        
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 300)
        tableView.tableFooterView = footerView
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 88)
        footerView.settingsDelegate=self
        tableView.register(SettingsCell.self, forCellReuseIdentifier: reuseIdentifier)
        
    }
   
}

extension SettingsController : SettingsHeaderDelegate{
    func settingsHeader(_ header: SettingsHeader, selectedIndex index: Int) {
        imageIndex = index
        present(imagePicker, animated: true, completion: nil)
        
        
    }
    
    
}
//MARK: -TableView DataSource

extension SettingsController {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return SettingsSections.allCases.count
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! SettingsCell
        guard let section = SettingsSections(rawValue: indexPath.section) else{return cell}
        let viewModel = SettingsViewModel(user: user, section: section)
        cell.viewModel = viewModel
        cell.delegate = self
        
        return cell
    }
    
}
//MARK: -TableView Delegate

extension SettingsController {
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 32
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = SettingsSections(rawValue: section) else{return nil}
        return section.description
        
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SettingsSections(rawValue: indexPath.section) else{return 0}

        return section == .ageRange ? 96 : 44
    }
    
    
}
//MARK: -UIImagePickerControllerDelegate
extension SettingsController :UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selectedImage = info[.originalImage] as? UIImage else {return}
        uploadImage(image: selectedImage)
        setHeaderImage(selectedImage)
        dismiss(animated: true, completion: nil)
    }
}

//MARK: -SettingsCellDelegate

extension SettingsController : SettingsCellDelegate{
    func settingCell(_ cell: SettingsCell, wantToUpdateAge sender: UISlider) {
        if sender == cell.minAgeSlider {
            user.minSeekingAge = Int(sender.value)
            
        }else{
            
            user.maxSeekingAge = Int(sender.value)
            
        }
        
    }
    
    func settingCell(_ cell: SettingsCell, wantToUpdateUserWith value: String, for section: SettingsSections) {
        switch section {
            
        case .name:
            user.name = value
        case .profession:
            user.profession = value
        case .age:
            user.age = Int(value) ?? user.age
        case .bio:
            user.bio = value
        case .ageRange:
            break
        }
       
    }
    
    
    
    
}
extension SettingsController : SettingsFooterDelegate {
    func handleLogout(){
        delegate?.settingsControllerWantsToLogout(self)
    }
    
    
}
