//
//  ViewController.swift
//  KlasHelper
//
//  Created by 융미 on 08/02/2019.
//  Copyrigh/Users/yoonmee/Desktop/dev/Application/KlasHelperRemaster/frontend/ios/KlasHelper/HideShowPasswordTextField/HideShowPasswordTextField.swiftt © 2019 devOTTO. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var passwordTextField: HideShowPasswordTextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupPasswordTextField()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
// MARK: UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, textField string: String) -> Bool {
        return passwordTextField.textField(textField: textField, shouldChangeCharactersInRange: range, replacementString: string)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        passwordTextField.textFieldDidEndEditing(textField: textField)
    }
}

// MARK: Private helpers
extension ViewController {
    private func setupPasswordTextField() {
        passwordTextField.passwordDelegate = self as? HideShowPasswordTextFieldDelegate
        passwordTextField.delegate = self
        passwordTextField.borderStyle = .none
        passwordTextField.clearButtonMode = .whileEditing
        passwordTextField.layer.borderWidth = 0.5
        passwordTextField.layer.borderColor = UIColor(red: 220/255.0, green: 220/255.0, blue: 220/255.0, alpha: 1.0).cgColor
        passwordTextField.borderStyle = UITextField.BorderStyle.none
        passwordTextField.clipsToBounds = true
        passwordTextField.layer.cornerRadius = 0
        
        passwordTextField.rightView?.tintColor = UIColor(red: 0.204, green: 0.624, blue: 0.847, alpha: 1)
        
        
        // left view hack to add padding
        passwordTextField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 3))
        passwordTextField.leftViewMode = .always
    }
}
