//
//  CustomInputView.swift
//  Fire
//
//  Created by mohamed elgharpawi on 11/6/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit

protocol CustomInputAccessoryViewDelegate : class {
    func inputView(_ inputView : CustomInputAccessoryView ,wantsToSendMessage message: String)
}

class CustomInputAccessoryView: UIView {
    
    //MARK:- Proprities
    
    weak var delegate: CustomInputAccessoryViewDelegate?
    
   private lazy var inputTextView : UITextView = {
        let tv  = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.isScrollEnabled =  false
    
        return tv
        
    }()
    
   private lazy var sendButton : UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Send", for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        btn.setTitleColor(.black, for: .normal)
        btn.addTarget(self, action: #selector(handleSendMsg), for: .touchUpInside)
        return btn
    }()
    
    private let placeholdrLabel : UILabel = {
        let label = UILabel()
        label.text = "Enter your Message ..."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
        
    }()
    //MARK:- Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        autoresizingMask = .flexibleHeight
        backgroundColor = .white
        layer.shadowOpacity = 0.25
        layer.shadowOffset = .init(width: 0, height: -8)
        layer.shadowRadius = 10
        layer.shadowColor = UIColor.lightGray.cgColor
        addSubview(sendButton)
        sendButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 4,  paddingRight: 8)
        sendButton.setDimensions(height: 50, width: 50)
        addSubview(inputTextView)
        inputTextView.anchor(top: topAnchor, left: leftAnchor,
                             bottom: safeAreaLayoutGuide.bottomAnchor,
                             right: sendButton.leftAnchor,
                             paddingTop: 12, paddingLeft: 4, paddingBottom: 8, paddingRight: 8 )
        
        
        addSubview(placeholdrLabel)
        placeholdrLabel.anchor(top: topAnchor, left: inputTextView.leftAnchor,
                               paddingTop: 4, paddingLeft: 8)
        placeholdrLabel.centerY(inView: inputTextView)
        
        NotificationCenter.default.addObserver(self, selector:#selector(controlPlacrholder), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize{
        return .zero
    }
    //MARK:- Actions

    @objc func handleSendMsg(){
        guard let message = inputTextView.text else{return}
        delegate?.inputView(self, wantsToSendMessage: message)
    }
    @objc func controlPlacrholder(){
        
        placeholdrLabel.isHidden = !self.inputTextView.text.isEmpty
    }
    
    
    //MARK:- Helpers
    func clearInputTextView()  {
        inputTextView.text = nil
        placeholdrLabel.isHidden = false
    }

    
}
