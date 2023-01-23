//
//  TabbarViewController.swift
//  RESET Life Skills App
//
//  Created by Vijay Rathore on 09/12/22.
//
import Firebase
import FirebaseMessaging
import UIKit


class TabbarViewController : UITabBarController, UITabBarControllerDelegate {
  
    var tabBarItems = UITabBarItem()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate  = self

        
        let selectedImage1 = UIImage(named: "quotation")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage1 = UIImage(named: "quotation-3")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![0]
        tabBarItems.image = deSelectedImage1
        tabBarItems.selectedImage = selectedImage1
        
        let selectedImage2 = UIImage(named: "play-3")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage2 = UIImage(named: "play-2")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![1]
        tabBarItems.image = deSelectedImage2
        tabBarItems.selectedImage = selectedImage2
        
        let selectedImage3 = UIImage(named: "setting")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage3 = UIImage(named: "setting-2")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![2]
        tabBarItems.image = deSelectedImage3
        tabBarItems.selectedImage = selectedImage3

        
        selectedIndex = 0
        updateFCMToken()
    }
    func updateFCMToken(){
        UserModel.data?.notiToken = Messaging.messaging().fcmToken
        Firestore.firestore().collection("Users").document(Auth.auth().currentUser!.uid).setData(["notiToken" : Messaging.messaging().fcmToken ?? ""], merge: true)
    }
}


