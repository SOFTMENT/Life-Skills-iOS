//
//  AddHelpViewController.swift
//  Life Skills App
//
//  Created by Vijay Rathore on 04/01/23.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class AddHelpViewController : UIViewController {

    @IBOutlet weak var titleTF: UITextField!
    @IBOutlet weak var linkTF: UITextField!
    
    @IBOutlet weak var addBtn: UIButton!
    override func viewDidLoad() {
        
        addBtn.layer.cornerRadius = 12
        linkTF.layer.cornerRadius = 12
        linkTF.delegate = self
        linkTF.addBorder()
        
     
        titleTF.delegate = self
        titleTF.layer.cornerRadius = 12
        titleTF.addBorder()

        
    }
    

    
    @IBAction func backBtnClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    

 
    @IBAction func addContact(_ sender: Any) {
        
        let sQuotes = linkTF.text
        let sTitle = titleTF.text
        
        if sTitle == "" {
            showSnack(messages: "Enter Title")
        }
        else if sQuotes == "" {
            showSnack(messages: "Enter Link")
        }
        else {
           
            ProgressHUDShow(text: "Adding...")
            let contactModel = ContactModel()
            contactModel.id = Firestore.firestore().collection("Contacts").document().documentID
            contactModel.createDate = Date()
            contactModel.title = sTitle
            contactModel.message = sQuotes
            addContactOnFirebase(contactModel: contactModel)
           
        }
        
    }
    
    func addContactOnFirebase(contactModel : ContactModel){
        
        try? Firestore.firestore().collection("Contacts").document(contactModel.id!).setData(from:contactModel,completion: { error in
            self.ProgressHUDHide()
            if error == nil {
                self.showSnack(messages: "Added")
                self.titleTF.text = ""
                self.linkTF.text = ""
            }
            else {
             
                self.showError(error!.localizedDescription)
                
            }
        })
            
            
         
    }
    
   
}




extension AddHelpViewController :  UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true;
    }
  



    
}
