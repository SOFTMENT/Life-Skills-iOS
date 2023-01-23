//
//  HelpCenter.swift
//  RESET Life Skills App
//
//  Created by Vijay Rathore on 10/12/22.
//

import UIKit
import Firebase
import FirebaseFirestoreSwift

class HelpCenterViewController : UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var contactModels : [ContactModel] = []
    
    override func viewDidLoad() {

        tableView.delegate = self
        tableView.dataSource = self
        getAllContact()
    }
    
    public func getAllContact(){
        ProgressHUDShow(text: "")
        Firestore.firestore().collection("Contacts").order(by: "createDate",descending: false).getDocuments { snapshot, error in
            self.ProgressHUDHide()
            if error == nil {
                self.contactModels.removeAll()
                if let snap = snapshot, !snap.isEmpty {
                    for qdr in  snap.documents{
                        if let notification = try? qdr.data(as: ContactModel.self) {
                            self.contactModels.append(notification)
                        }
                    }
                   
                }
                self.tableView.reloadData()
            }
            else {
                self.showError(error!.localizedDescription)
            }
        }
    }

    
    @objc func cellClicked(value : MyGesture){
        let model = contactModels[value.index]
        if model.message!.contains("@") {
      
            if let url = URL(string: "mailto:\(model.message!)") {
                if #available(iOS 10.0, *) {
                    UIApplication.shared.open(url)
                } else {
                    UIApplication.shared.openURL(url)
                }
            }
        }
        else {
          
            guard let url = URL(string: "https://\(model.message!)") else { return }
            UIApplication.shared.open(url)
        }
        
      
    }
   
    
    @IBAction func backClicked(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }

}


extension HelpCenterViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contactModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "contactuscell", for: indexPath) as? Contact_Us_View {
            
            cell.mView.layer.cornerRadius = 8
            let contactModel = self.contactModels[indexPath.row]
            cell.mTitle.text = contactModel.title ?? ""
            cell.mMessage.text = contactModel.message ?? ""
            cell.mView.isUserInteractionEnabled = true
            let myGest = MyGesture(target: self, action: #selector(cellClicked(value: )))
            myGest.index = indexPath.row
            cell.mView.addGestureRecognizer(myGest)
            
            return cell
        }
        return Contact_Us_View()
    }
    
    
    
    
}


