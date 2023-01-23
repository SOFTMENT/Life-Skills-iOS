//
//  AdminSettingsViewController.swift
//  RESET Life Skills App
//
//  Created by Vijay Rathore on 10/12/22.
//

import UIKit
import Firebase
import StoreKit

class AdminSettingsViewController : UIViewController {
    
    
    @IBOutlet weak var userPanelView: UILabel!
    @IBOutlet weak var pImage: UIImageView!
    
    @IBOutlet weak var sendPushNotifications: UIView!
    
    @IBOutlet weak var version: UILabel!
    @IBOutlet weak var policyView: UIView!
    @IBOutlet weak var termsOfView: UIView!

 
    
    override func viewDidLoad() {
        
        
   
     
     
        pImage.layer.cornerRadius = 12
        
        
        let appVersion = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as? String
        version.text  = "\(appVersion ?? "1.0")"
        
        policyView.isUserInteractionEnabled = true
        policyView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(redirectToPrivacyPolicy)))
        
        termsOfView.isUserInteractionEnabled = true
        termsOfView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(redirectToPrivacyPolicy)))
        
       
        
        sendPushNotifications.isUserInteractionEnabled = true
        sendPushNotifications.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(sendPushNotificationsClicked)))
        
   
    }
    


    @objc func sendPushNotificationsClicked(){
        performSegue(withIdentifier: "manageHelpCenterSeg", sender: nil)
    }
    


    

    @objc func redirectToTermsOfService() {
        
        guard let url = URL(string: "https://softment.in/terms-of-service/") else { return}
        UIApplication.shared.open(url)
    }
    
    @objc func redirectToPrivacyPolicy() {
        
        guard let url = URL(string: "https://softment.in/privacy-policy/") else { return}
        UIApplication.shared.open(url)
    }
    
  



}





