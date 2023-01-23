//
//  EditHelpViewController.swift
//  Life Skills App
//
//  Created by Vijay Rathore on 05/01/23.
//


import UIKit
import Firebase
import FirebaseFirestoreSwift

class EditHelpViewController : UIViewController {

    @IBOutlet weak var linkTF: UITextField!
    @IBOutlet weak var addBtn: UIButton!
    
    @IBOutlet weak var titleTF: UITextField!
    var contactModel : ContactModel?

    override func viewDidLoad() {

        guard let contactModel = contactModel else {
            
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
            
            return
        }
        
        addBtn.layer.cornerRadius = 12
        linkTF.layer.cornerRadius = 12
        linkTF.delegate = self
        linkTF.text = contactModel.message ?? ""
        linkTF.addBorder()
        
     
        titleTF.delegate = self
        titleTF.text = contactModel.title ?? ""
        titleTF.layer.cornerRadius = 12
        titleTF.addBorder()

        
    }
    

    

    @IBAction func backBtnClicked(_ sender: Any) {
        
        
        self.dismiss(animated: true, completion: nil)
    }
    


    @IBAction func editContact(_ sender: Any) {
        
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
    
            self.contactModel!.title = sTitle
            self.contactModel!.message = sQuotes
            self.addContactOnFirebase(contactModel: self.contactModel!)
           
        }
    }
    
    func addContactOnFirebase(contactModel : ContactModel){
        
        try? Firestore.firestore().collection("Contacts").document(contactModel.id!).setData(from:contactModel,completion: { error in
            self.ProgressHUDHide()
            if error == nil {
                self.showSnack(messages: "Edited")
               
            }
            else {
             
                self.showError(error!.localizedDescription)
                
            }
        })
            
            
         
    }
    
   
}




extension EditHelpViewController :  UITextFieldDelegate{
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true;
    }
  



    
}
