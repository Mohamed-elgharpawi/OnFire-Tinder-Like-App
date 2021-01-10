//
//  AlertView.swift
//  Fire
//
//  Created by mohamed elgharpawi on 11/5/20.
//  Copyright © 2020 mohamed elgharpawi. All rights reserved.
//

import UIKit
import ProgressHUD

class AlertView {
    static func showAlert(controller :UIViewController,title: String, msg: String) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: title, message: msg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                controller.present(alert, animated: true, completion: nil)
            }
}
    
    static func showLoader(withMessage message : String)  {
        ProgressHUD.animationType = .circleRotateChase
        ProgressHUD.show(message,interaction: false)
    }


}

    
