//
//  AdminTabbarViewController.swift
//  RESET Life Skills App
//
//  Created by Vijay Rathore on 10/12/22.
//

import UIKit


class AdminTabbarViewController : UITabBarController, UITabBarControllerDelegate {
  
    var tabBarItems = UITabBarItem()
 
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate  = self

        
        let selectedImage1 = UIImage(named: "quotation")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage1 = UIImage(named: "quotation-4")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![0]
        tabBarItems.image = deSelectedImage1
        tabBarItems.selectedImage = selectedImage1
        
        let selectedImage2 = UIImage(named: "play-3")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage2 = UIImage(named: "play-4")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![1]
        tabBarItems.image = deSelectedImage2
        tabBarItems.selectedImage = selectedImage2
        
        let selectedImage3 = UIImage(named: "setting-4")?.withRenderingMode(.alwaysOriginal)
        let deSelectedImage3 = UIImage(named: "setting-3")?.withRenderingMode(.alwaysOriginal)
        tabBarItems = self.tabBar.items![2]
        tabBarItems.image = deSelectedImage3
        tabBarItems.selectedImage = selectedImage3

        
        selectedIndex = 0
        

    }
   
}


