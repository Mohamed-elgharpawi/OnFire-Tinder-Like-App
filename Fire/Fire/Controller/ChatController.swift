//
//  ChatController.swift
//  Fire
//
//  Created by mohamed elgharpawi on 11/5/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit
private let identifier = "Chat Cell"

class ChatController: UICollectionViewController {
    
    //MARK : - proprities
    let user : User
    private var messages = [Message]()
    private var fromCurrentUser = false
    private lazy var customInputView:CustomInputAccessoryView = {
        let iv = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        return iv
    }()
    
    //MARK : - Lifecycle

    
    init (user : User){
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        configNavigationBar()
        customInputView.delegate = self
        fetchMessages()
    }
    override var inputAccessoryView: UIView?{
        get{ return customInputView }
        
    }
    override var canBecomeFirstResponder: Bool{return true}
    
    //MARK: - API
    
    func fetchMessages()  {
        Service.fetchMessages(forUser: user) { (messages) in
            self.messages = messages
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0,messages.count-1], at: .bottom, animated: true)
        }
    }
    
    
    
    //MARK : - Helpers
    
    func configUI() {
        collectionView.backgroundColor = .white
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: identifier)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }
    func configNavigationBar() {
        let leftButton = UIImageView()
        leftButton.setDimensions(height:15, width: 15)
        leftButton.isUserInteractionEnabled = true
        leftButton.image = #imageLiteral(resourceName: "back").withRenderingMode(.alwaysTemplate)
        leftButton.tintColor = #colorLiteral(red: 0.1411764771, green: 0.3960784376, blue: 0.5647059083, alpha: 1)
        let tap = UITapGestureRecognizer(target: self, action: #selector(handelDismiss))
        leftButton.addGestureRecognizer(tap)
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftButton)
        navigationItem.title = user.name

        
    }
    
    @objc func handelDismiss(){
        self.dismiss(animated: true, completion: nil)
    }

    
    
    
}
extension ChatController{
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        cell.message?.user = user
        return cell
    }
}

extension ChatController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let estimatedSizeCell = MessageCell(frame: frame)
        estimatedSizeCell.message = messages[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()

        let targetSize = CGSize(width: view.frame.width, height: 1000)

        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
        return .init(width: view.frame.width, height: estimatedSize.height)

    }
}

//MARK:- CustomInputAccessoryViewDelegate
extension ChatController : CustomInputAccessoryViewDelegate {
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSendMessage message: String) {
        Service.uploadMessage(message, to: user) { (error) in
            if let error = error {
                print("Erorr : \(error.localizedDescription)")
                return
            }
            self.customInputView.clearInputTextView()
        }


    }
    
    
    
}
