//
//  AdminMessagesViewController.swift
//  RESET Life Skills App
//
//  Created by Vijay Rathore on 09/12/22.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift
import SDWebImage

class AdminMessagesViewController : UIViewController {

   
    @IBOutlet weak var tableView: UITableView!
    
    var dailyInsightsModels = Array<DailyMessageModel>()
    let docId = ""
    override func viewDidLoad() {
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isEditing = true
        
        //GetDailyInsights
        getDailyInsights()
        
      
        
    }
    
    
    @IBAction func homeBtnClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func addInsights(_ sender: Any) {
        
        performSegue(withIdentifier: "addMessageSeg", sender: nil)
        
    }
    
    @objc func editInsight(value : MyGesture){
        let dailyModel = dailyInsightsModels[value.index]
        performSegue(withIdentifier: "editMessageSeg", sender: dailyModel)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editMessageSeg" {
            if let vc = segue.destination as? AdminEditMessageViewController {
                if let dailyModel = sender as? DailyMessageModel {
                    vc.dailyInsight = dailyModel
                }
            }
        }
    }
    
    func getDailyInsights(){
        ProgressHUDShow(text: "Loading...")
        Firestore.firestore().collection("DailyInsights").order(by: "count", descending: true).addSnapshotListener { snap, err in
            self.ProgressHUDHide()
            if err == nil {
                self.dailyInsightsModels.removeAll()
                if let snap = snap {
                    for mySnap in snap.documents {
                        if let dailyInsight = try? mySnap.data(as: DailyMessageModel.self) {
                            self.dailyInsightsModels.append(dailyInsight)
                        }
                      
                    }
                }
                self.tableView.reloadData()
                
            }
            else {
                self.showError(err!.localizedDescription)
            }
        }
    }
    
    @objc func deleteBtnTapped(myTap : MyTapGesture){
        let alert = UIAlertController(title: "Delete", message: "Are you sure you want to delete this message?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive,handler: { action in
            Firestore.firestore().collection("DailyInsights").document(String(myTap.docId)).delete()
            self.showSnack(messages: "Deleted")
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(alert, animated: true)
        
    }
}

extension AdminMessagesViewController : UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dailyInsightsModels.swapAt(sourceIndexPath.row, destinationIndexPath.row)
        var i = dailyInsightsModels.count
        for dailyModel in dailyInsightsModels {
            dailyModel.count = i
            try? Firestore.firestore().collection("DailyInsights").document(String(dailyModel.id ?? 1)).setData(from: dailyModel,merge : true)
            i = i - 1
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dailyInsightsModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
       if let cell = tableView.dequeueReusableCell(withIdentifier: "adminmessagecell", for: indexPath) as? MessageTableViewCell {
            
            cell.mView.layer.cornerRadius = 8
            
     
      
         let dailyInsight = dailyInsightsModels[indexPath.row]
     
        cell.quote.text = dailyInsight.quotes ?? ""
           cell.title.text = dailyInsight.title ?? ""
        cell.deleteBtn.isUserInteractionEnabled = true
        
        let myTap = MyTapGesture(target: self, action: #selector(deleteBtnTapped(myTap:)))
        myTap.docId = dailyInsight.id ?? 0
        cell.deleteBtn.addGestureRecognizer(myTap)
        
           
           cell.mView.isUserInteractionEnabled = true
           let editGest = MyGesture(target: self, action: #selector(editInsight(value: )))
           editGest.index = indexPath.row
           cell.mView.addGestureRecognizer(editGest)
        
          return cell
        }
        return MessageTableViewCell()
    }
    
    
    
}


class MyTapGesture: UITapGestureRecognizer {

    var docId = 0
    
}
