//
//  AdminEditMessageViewController.swift
//  Life Skills App
//
//  Created by Vijay Rathore on 17/12/22.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class AdminEditMessageViewController : UIViewController {

    @IBOutlet weak var addMessageBtn: UIButton!
    
    @IBOutlet weak var titleTF: UITextField!
    
    @IBOutlet weak var quote: UITextView!
    var isImageChanged = false
   
    var dailyInsight : DailyMessageModel?
    let placeholderText = "Enter Quote"
    override func viewDidLoad() {
        
        guard let dailyInsight = dailyInsight else {
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
            return
        }
        
        addMessageBtn.layer.cornerRadius = 12
        quote.layer.cornerRadius = 12
     
       
        
        quote.textColor = UIColor.lightGray
        quote.text = "Enter Quote"
        quote.delegate = self
        quote.addBorder()
        
        titleTF.delegate = self
        titleTF.layer.cornerRadius = 12
        titleTF.addBorder()
        titleTF.text = dailyInsight.title ?? ""
        quote.text = dailyInsight.quotes ?? ""

    }
    
    
    @IBAction func backBtnClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
   
   
    
   

  
    @IBAction func addInsightsBtnClicked(_ sender: Any) {
        let sQuotes = quote.text
        let sTitle = titleTF.text
        
        if sTitle == "" {
            showSnack(messages: "Enter Title")
        }
        else if sQuotes == "" {
            showSnack(messages: "Enter Quote")
        }
        else {
           
                ProgressHUDShow(text: "Updating..")
               
                        let messageModel = DailyMessageModel()
                        messageModel.title = sTitle ?? ""
                        messageModel.quotes = sQuotes ?? ""
                        
                       
                                    self.uploadMessage(messageModel: messageModel)
                                }
        
        
       
    }
    
    func uploadMessage(messageModel : DailyMessageModel){
        
        try? Firestore.firestore().collection("DailyInsights").document(String.init(dailyInsight!.id ?? 1)).setData(from: messageModel, merge : true,completion: { error in
            self.ProgressHUDHide()
            if error == nil {
                self.showSnack(messages: "Message Updated")
            
            }
            else {
             
                self.showError(error!.localizedDescription)
                
            }
        })
            
            
         
    }
    
   
}




extension AdminEditMessageViewController :  UITextFieldDelegate, UITextViewDelegate {
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true;
    }
  
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        if textView.text == placeholderText {
            textView.textColor = UIColor.darkGray
            textView.text = ""
        }
        return true
    }
    


    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = UIColor.lightGray
            textView.text = placeholderText
        }
    }
    
}
