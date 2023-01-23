//
//  AccountViewController.swift
//  RESET Life Skills App
//
//  Created by Vijay Rathore on 09/12/22.
//

import UIKit
import Firebase
import StoreKit

class AccountViewController : UIViewController {
    
    
    @IBOutlet weak var pImage: UIImageView!
    
    @IBOutlet weak var mName: UILabel!
    
    @IBOutlet weak var mEmail: UILabel!
    @IBOutlet weak var membershipView: UIView!
    @IBOutlet weak var membershipDays: UILabel!
    
    
    @IBOutlet weak var adminPanelView: UIView!
    @IBOutlet weak var helpCentre: UIView!
    @IBOutlet weak var rateApp: UIView!
    @IBOutlet weak var shareApp: UIView!
    @IBOutlet weak var deleteAccount: UIView!
    
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var policyView: UIView!
    @IBOutlet weak var termsOfView: UIView!
    
    @IBOutlet weak var logout: UILabel!
    
    override func viewDidLoad() {
        
        
        guard let user = UserModel.data else {
            return
        }
        
        
      
        if user.email == "iamvijay67@gmail.com" || user.email == "mjacobus@resetsummercamp.com"{
            adminPanelView.isHidden = false
        }
        
        mName.text = user.fullName
        mEmail.text = user.email
        
        pImage.layer.cornerRadius = 12
        membershipView.layer.cornerRadius = 8
        
        
        rateApp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rateAppBtnClicked)))
        shareApp.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(inviteFriendBtnClicked)))
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        version.text  = "\(appVersion ?? "1.0")"
        
        policyView.isUserInteractionEnabled = true
        policyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(redirectToPrivacyPolicy)))
        
        termsOfView.isUserInteractionEnabled = true
        termsOfView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(redirectToPrivacyPolicy)))
        
        //Logout
        logout.isUserInteractionEnabled = true
        logout.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(logoutBtnClicked)))
        
        
        
        //HelpCentre
        helpCentre.isUserInteractionEnabled = true
        helpCentre.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(helpCentreBtnClicked)))
        
        
        
        //DELETE ACCOUNT
        
        deleteAccount.isUserInteractionEnabled = true
        deleteAccount.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteAccountBtnClicked)))
        
        //ADMIN PANEL
        adminPanelView.isUserInteractionEnabled = true
        adminPanelView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(adminPanelClicked)))
        

        let daysleft = self.membershipDaysLeft(currentDate: Constants.currentDate, expireDate: Constants.expireDate) + 1
        if daysleft > 1 {
            self.membershipDays.text = "\(daysleft) Days Left"
        }
        else {
            
            self.membershipDays.text = "\(daysleft) Day Left"
            
        }
    }
    
    @objc func adminPanelClicked(){
        performSegue(withIdentifier: "adminPanelSeg", sender: nil)
    }
    
    @objc func deleteAccountBtnClicked(){
        let alert = UIAlertController(title: "DELETE ACCOUNT", message: "Are you sure you want to delete your account?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { action in
            
            if let user = Auth.auth().currentUser {
                
                self.ProgressHUDShow(text: "Account Deleting...")
                let userId = user.uid
                
                        Firestore.firestore().collection("Users").document(userId).delete { error in
                           
                            if error == nil {
                                user.delete { error in
                                    self.ProgressHUDHide()
                                    if error == nil {
                                        self.logout()
                                        
                                    }
                                    else {
                                        self.beRootScreen(mIdentifier: Constants.StroyBoard.signInViewController)
                                    }
    
                                
                                }
                                
                            }
                            else {
                       
                                self.showError(error!.localizedDescription)
                            }
                        }
                    
                }
            
            
        }))
        present(alert, animated: true)
    }
       
//    @objc func goPremiumClicked(){
//
//        if let tabbar = tabBarController as? TabBarViewController {
//            if(self.checkMembershipStatus(currentDate: Constants.currentDate, expireDate: UserData.data!.expireDate ?? Constants.currentDate)) {
//                tabbar.showMembership()
//            }
//            else {
//                tabbar.goPremium()
//            }
//        }
//
//
//    }
    
    
    
    
   
    
    @objc func helpCentreBtnClicked(){
        
    
        performSegue(withIdentifier: "helpSeg", sender: nil)
    }
    

    

    @objc func redirectToTermsOfService() {
        
        guard let url = URL(string: "https://softment.in/terms-of-service/") else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func redirectToPrivacyPolicy() {
        
        guard let url = URL(string: "https://softment.in/privacy-policy/") else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func inviteFriendBtnClicked(){
        
        let someText:String = "Check Out RESET Life Skills App Now."
        let objectsToShare:URL = URL(string: "https://apps.apple.com/us/app/life-skills-app/id1659090655?ls=1&mt=8")!
        let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func rateAppBtnClicked(){
        if #available(iOS 14.0, *) {
              if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
                  SKStoreReviewController.requestReview(in: scene)
              }
        }
        else  if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        }
        else if let url = URL(string: "itms-apps://itunes.apple.com/app/" + "1659090655") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
 
    @objc func logoutBtnClicked(){
        
        let alert = UIAlertController(title: "LOGOUT", message: "Are you sure you want to logout?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { action in
            self.logout()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
        
      
    }


}





