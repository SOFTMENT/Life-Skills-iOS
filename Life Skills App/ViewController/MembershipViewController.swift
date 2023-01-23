//
//  MembershipViewController.swift
//  Life Skills App
//
//  Created by Vijay Rathore on 04/01/23.
//

import UIKit
import Firebase
import RevenueCat

class MembershipViewController : UIViewController {
    @IBOutlet weak var backBtn: UIView!
    

    @IBOutlet weak var purchaseBtn: UIButton!
    @IBOutlet weak var restoreBtn: UILabel!
    @IBOutlet weak var termsOfUseBtn: UILabel!
    @IBOutlet weak var privacyPolicyBtn: UILabel!

    override func viewDidLoad() {
       
        backBtn.isUserInteractionEnabled = true
        backBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(backBtnClicked)))
        backBtn.layer.cornerRadius = 8
        backBtn.dropShadow()
        
        purchaseBtn.layer.cornerRadius = 8
        
        Purchases.shared.logIn(Auth.auth().currentUser!.uid) { (customerInfo, created, error) in
          
        }
        
        termsOfUseBtn.isUserInteractionEnabled = true
        termsOfUseBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(termsOfUseClicked)))
        
        privacyPolicyBtn.isUserInteractionEnabled = true
        privacyPolicyBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(privacyPolicyClicked)))
        
       
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
        restoreBtn.isUserInteractionEnabled = true
        restoreBtn.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(restoreBtnClicked)))
    }
    
    @objc func restoreBtnClicked(){
        self.ProgressHUDShow(text: "Restoring...")
        Purchases.shared.restorePurchases { customerInfo, error in
            self.ProgressHUDHide()
            if customerInfo?.entitlements.all["Premium"]?.isActive == true {
                Constants.expireDate = customerInfo?.entitlements.all["Premium"]?.expirationDate ?? Date()
                self.beRootScreen(mIdentifier: Constants.StroyBoard.tabBarViewController)
            }
            else {
                self.showSnack(messages: "No active membership found")
            }
        }
    }
    
    @objc func termsOfUseClicked(){
        guard let url = URL(string: "https://softment.in/terms-of-service/") else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func privacyPolicyClicked(){
        guard let url = URL(string: "https://softment.in/privacy-policy/") else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func hideKeyboard(){
        self.view.endEditing(true)
    }
    
    @objc func backBtnClicked() {
        self.logout()
    }
    
    @IBAction func prucahseBtnClicked(_ sender: Any) {
        Purchases.shared.getOfferings { (offerings, error) in
            if let offerings = offerings {
                var package : Package?
               
                package = offerings.current?.availablePackages[0]
                
                
                self.ProgressHUDShow(text: "")
              
                Purchases.shared.purchase(package: package!) { (transaction, customerInfo, error, userCancelled) in
                    self.ProgressHUDHide()
                    if let error = error {
                        self.showError(error.localizedDescription)
                    }
                    else {
                     
                        if let userModel = UserModel.data {
                            userModel.membership = true
                            try? Firestore.firestore().collection("Users").document(userModel.uid ?? "123").setData(from: userModel, merge : true)
                        }
                        
                        if customerInfo?.entitlements.all["Premium"]?.isActive == true {
                            Constants.expireDate = customerInfo?.entitlements.all["Premium"]?.expirationDate ?? Date()
                            self.beRootScreen(mIdentifier: Constants.StroyBoard.tabBarViewController)
                        }
                        
                    }
                }
          }
        }
        
    }

}


extension MembershipViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}
