//
//  SettingsCell.swift
//  Fire
//
//  Created by mohamed elgharpawi on 9/21/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit

protocol SettingsCellDelegate : class {
    
    func settingCell(_ cell : SettingsCell, wantToUpdateUserWith value:String,for section: SettingsSections)
    func settingCell(_ cell : SettingsCell, wantToUpdateAge sender:UISlider)
    
    
}

class SettingsCell: UITableViewCell {
   //MARK: -Prorities
    weak var delegate :SettingsCellDelegate?
    var  viewModel:SettingsViewModel! {
        didSet{ configure() }
    }
    lazy var inputField:UITextField = {
        let textField = UITextField()
        textField.borderStyle = .none
        
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.placeholder = "Enter something here.."
        let paddingView = UIView()
        paddingView.setDimensions(height: 50, width: 25)
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
        
    }()
    var sliderStack = UIStackView()
    let minAgeLabel = UILabel()
    let maxAgeLable = UILabel()
    lazy var minAgeSlider = createAgeSlider()
    lazy var maxAgeSlider = createAgeSlider()
    
    

  //MARK: -Lifecycle
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        minAgeLabel.text = "Min: 18"
        maxAgeLable.text = "Max: 60"
        
        contentView.addSubview(inputField)
        
        inputField.fillSuperview()
        let minStack = UIStackView(arrangedSubviews: [minAgeLabel,minAgeSlider])
        minStack.spacing = 24
        let maxStack = UIStackView(arrangedSubviews: [maxAgeLable,maxAgeSlider])
        maxStack.spacing = 24
        sliderStack = UIStackView(arrangedSubviews: [minStack,maxStack])
        sliderStack.axis = .vertical
        sliderStack.spacing = 16

        contentView.addSubview(sliderStack)
        sliderStack.centerY(inView: self)
        sliderStack.anchor(left: leftAnchor ,right: rightAnchor, paddingLeft: 24, paddingRight: 24)


    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    //MARK: -Helpers
    func configure()  {
        inputField.isHidden = viewModel.shouldHideInputField
        sliderStack.isHidden = viewModel.shouldHideAgeRange
        inputField.placeholder = viewModel.placeholderText
        inputField.text = viewModel.value

        inputField.addTarget(self, action: #selector(handelUpdateUserInfo), for: .editingDidEnd)
        minAgeSlider.setValue(viewModel.minAgeSliderValue, animated: true)
        maxAgeSlider.setValue(viewModel.maxAgeSliderValue, animated: true)
        minAgeLabel.text = viewModel.maxAgeLabelText(forValue: viewModel.minAgeSliderValue)
        maxAgeLable.text = viewModel.maxAgeLabelText(forValue: viewModel.maxAgeSliderValue)

        
    }
    func createAgeSlider() -> UISlider {
        let slider = UISlider()
        slider.maximumValue = 60
        slider.minimumValue = 18
        slider.addTarget(self, action: #selector(handelAgeRangeSlider), for: .valueChanged)
        return slider
    }
    //MARK: -Actions
    @objc func handelUpdateUserInfo(sender : UITextField){
        guard let value = sender.text else{return}
        
        delegate?.settingCell(self, wantToUpdateUserWith: value ,for: viewModel.section)
    }
    
    @objc func handelAgeRangeSlider(sender : UISlider){
        if sender == minAgeSlider {
           // minAgeLabel.text = "Min: \(Int(sender.value))"
            //But Using View Model
            minAgeLabel.text = viewModel.minAgeLabelText(forValue: sender.value)
            
            
        }
        else{
            maxAgeLable.text = viewModel.maxAgeLabelText(forValue: sender.value)

        }
        self.delegate?.settingCell(self, wantToUpdateAge: sender)
        
        
    }

    
}
