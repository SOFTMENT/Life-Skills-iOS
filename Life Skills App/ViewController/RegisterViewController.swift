//
//  RegisterViewController.swift
//  RESET Life Skills App
//
//  Created by Vijay Rathore on 09/12/22.
//

import UIKit
import Firebase
import CropViewController

class RegisterViewController : UIViewController {
    
    
    @IBOutlet weak var backView: UIView!
    
    @IBOutlet weak var fullName: UITextField!
    
    @IBOutlet weak var emailAddress: UITextField!
    
    @IBOutlet weak var password: UITextField!
    
    @IBOutlet weak var registerBtn: UIButton!
    
    @IBOutlet weak var loginNow: UILabel!
    var isImageSelected = false
    
    
    
    override func viewDidLoad() {
     
        fullName.layer.cornerRadius = 12
        fullName.addBorder()
        fullName.setLeftPaddingPoints(10)
        fullName.setRightPaddingPoints(10)
        fullName.delegate = self
        
        emailAddress.layer.cornerRadius = 12
        emailAddress.addBorder()
        emailAddress.setLeftPaddingPoints(10)
        emailAddress.setRightPaddingPoints(10)
        emailAddress.delegate = self
        
        password.layer.cornerRadius = 12
        password.addBorder()
        password.setLeftPaddingPoints(10)
        password.setRightPaddingPoints(10)
        password.delegate = self
        
        loginNow.isUserInteractionEnabled = true
        loginNow.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        
        
        registerBtn.layer.cornerRadius = 12
        
        backView.isUserInteractionEnabled = true
        backView.layer.cornerRadius = 12
        backView.dropShadow()
        backView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func backBtnClicked(){
        self.dismiss(animated: true)
    }
    
    @IBAction func registerBtnClicked(_ sender: Any) {
        
        
        let sFullName = fullName.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sEmail = emailAddress.text?.trimmingCharacters(in: .whitespacesAndNewlines)
        let sPassword = password.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    
        if sFullName == "" {
            showSnack(messages: "Enter Full Name")
        }
        else if sEmail == "" {
            showSnack(messages: "Enter Email")
        }
        else if sPassword  == "" {
            showSnack(messages: "Enter Password")
        }
        else {
            ProgressHUDShow(text: "Creating Account...")
            Auth.auth().createUser(withEmail: sEmail!, password: sPassword!) { result, error in
                self.ProgressHUDHide()
                if error == nil {
                    let userData = UserModel()
                    userData.fullName = sFullName
                    userData.email = sEmail
                    userData.uid = Auth.auth().currentUser!.uid
                    userData.registredAt = Date()
                    userData.regiType = "custom"
                
                    self.addUserData(userData: userData)
                    
                
                }
                else {
                    self.showError(error!.localizedDescription)
                }
            }
        }
        
    }

}

extension RegisterViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.hideKeyboard()
        return true
    }
}

