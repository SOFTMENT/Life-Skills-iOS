//
//  AdminAddMessage.swift
//  RESET Life Skills App
//
//  Created by Vijay Rathore on 09/12/22.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class AdminAddMessageViewController : UIViewController {

    @IBOutlet weak var addMessageBtn: UIButton!
    
    @IBOutlet weak var titleTF: UITextField!
    
    @IBOutlet weak var quote: UITextView!
    var isImageChanged = false
   
    
    let placeholderText = "Enter Quote"
    override func viewDidLoad() {
        
        addMessageBtn.layer.cornerRadius = 12
        quote.layer.cornerRadius = 12
       
        
        quote.textColor = UIColor.lightGray
        quote.text = "Enter Quote"
        quote.delegate = self
        quote.addBorder()
        
        titleTF.delegate = self
        titleTF.layer.cornerRadius = 12
        titleTF.addBorder()
        
        
   
    
        
    }
    
    
    @IBAction func backBtnClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
   
    
    @objc func closeBtnTapped(){
     
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
           
                ProgressHUDShow(text: "Adding...")
                Firestore.firestore().collection("DailyInsights").limit(toLast: 1).order(by: "id").getDocuments { snap, error in
                    if error == nil {
                        let messageModel = DailyMessageModel()
                        messageModel.title = sTitle ?? ""
                        messageModel.quotes = sQuotes ?? ""
                        
                        if let snap = snap {
                            if !snap.isEmpty {
                                for s in snap.documents {
                                    let daily =  try?  s.data(as: DailyMessageModel.self)
                                    messageModel.id = (daily?.id ?? 1) + 1
                                    messageModel.count = messageModel.id ?? 1
                                    self.uploadMessage(messageModel: messageModel)
                                }
                            }
                            else {
                                messageModel.id =  1
                                messageModel.count = 1
                                self.uploadMessage(messageModel: messageModel)
                            }
                        }
                        else {
                            messageModel.id =  1
                            messageModel.count = 1
                            self.uploadMessage(messageModel: messageModel)
                        }
                    }
                    else {
                        self.ProgressHUDHide()
                        self.showError(error!.localizedDescription)
                    }
           
            }
        }
        
       
    }
    
    func uploadMessage(messageModel : DailyMessageModel){
        
        try? Firestore.firestore().collection("DailyInsights").document(String.init((messageModel.id ?? 1))).setData(from: messageModel,completion: { error in
            self.ProgressHUDHide()
            if error == nil {
                self.showSnack(messages: "Message Added")
                self.titleTF.text = ""
                self.quote.text = ""
            }
            else {
             
                self.showError(error!.localizedDescription)
                
            }
        })
            
            
         
    }
    
   
}




extension AdminAddMessageViewController :  UITextFieldDelegate, UITextViewDelegate {
    
    
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
