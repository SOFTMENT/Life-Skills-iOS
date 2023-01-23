//
//  QuoteViewController.swift
//  RESET Life Skills App
//
//  Created by Vijay Rathore on 09/12/22.
//


import Firebase
import FirebaseFirestoreSwift
import UIKit
import SDWebImage

class QuoteViewController : UIViewController {
    
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var share: UIImageView!
   
    @IBOutlet weak var year: UILabel!

    @IBOutlet weak var quote: UITextView!
    
    @IBOutlet weak var month: UILabel!
    
   
    @IBOutlet weak var mTitle: UILabel!
    
    override func viewDidLoad() {
        

        share.isUserInteractionEnabled = true
        share.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shareText)))
        
        getDailyInsight()
    
        //Share
        share.isUserInteractionEnabled = true
        share.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(shareText)))
        
      
    }


    @objc func shareText(){
        let text = "\(mTitle.text ?? "")\n\n\(quote.text ?? "")"
           let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare as [Any] , applicationActivities: nil)
           activityViewController.popoverPresentationController?.sourceView = self.view
           self.present(activityViewController, animated: true, completion: nil)
    }
    

    
    func getDailyInsight(){
        ProgressHUDShow(text: "Loading...")
        let lastId = UserModel.data?.lastQuotesId ?? 0
      
        Firestore.firestore().collection("DailyInsights").whereField("count", isGreaterThan: lastId).whereField("count", isLessThan: lastId + 4).getDocuments(completion: { snap, error in
         
          self.ProgressHUDHide()
            if error == nil {
                if let snap = snap {
                    if snap.documents.count > 0 {
                        if let qds = snap.documents.first {
                            if let dailyInsightsModel = try? qds.data(as: DailyMessageModel.self) {
                                
                                let day = Calendar.current.component(.day, from: Date())
                                let month = Calendar.current.monthSymbols[Calendar.current.component(.month, from: Date()) - 1]
                                let year = Calendar.current.component(.year, from: Date())
                    
                                self.day.text = String(day)
                                self.month.text = month
                                self.year.text = String(year)
                                
                                self.mTitle.text = dailyInsightsModel.title ?? ""
                                self.quote.text = dailyInsightsModel.quotes ?? ""
                        
                            }
                            else {
                                
                            }
                        }
                        else {
                         
                        }
                       
                    }
                    else{
                        
                      
                    }
                }
                else {
                  
                }
            
            }
            else {
                self.showError(error!.localizedDescription)
            }
        })
    }
    

    
  

}



