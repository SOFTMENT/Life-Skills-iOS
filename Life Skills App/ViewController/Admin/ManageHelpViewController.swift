//
//  ManageHelpViewController.swift
//  Life Skills App
//
//  Created by Vijay Rathore on 04/01/23.
//


import UIKit
import Firebase
import FirebaseFirestoreSwift

class ManageHelpViewController : UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var contactModels : [ContactModel] = []
    
    override func viewDidLoad() {

        tableView.delegate = self
        tableView.dataSource = self
        getAllContact()
    }
    
    
    @objc func cellClicked(value : MyGesture){
        
        let contactModel = contactModels[value.index]
        performSegue(withIdentifier: "editHelpSeg", sender: contactModel)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editHelpSeg" {
            if let vc = segue.destination as? EditHelpViewController {
                if let contactModel = sender as? ContactModel {
                    vc.contactModel = contactModel
                }
            }
        }
    }
    
    public func getAllContact(){
        ProgressHUDShow(text: "")
        Firestore.firestore().collection("Contacts").order(by: "createDate",descending: false).addSnapshotListener { snapshot, error in
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
    
    
    @IBAction func addContactClicked(_ sender: Any) {
        performSegue(withIdentifier: "addContactSeg", sender: nil)
    }
    
    @objc func deleteContact(value : MyGesture){
        ProgressHUDShow(text: "Deleting...")
        Firestore.firestore().collection("Contacts").document(value.id).delete { error in
            self.ProgressHUDHide()
            if let error = error {
                self.showError(error.localizedDescription)
            }
            else {
                self.showSnack(messages: "Deleted")
            }
        }
    }

    

    
    @IBAction func backClicked(_ sender: Any) {
        self.dismiss(animated: true)
      
    }

}


extension ManageHelpViewController : UITableViewDelegate, UITableViewDataSource {
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
            
            cell.delete.isUserInteractionEnabled = true
            let deleteGest = MyGesture(target: self, action: #selector(deleteContact(value: )))
            deleteGest.id = contactModel.id ?? "123"
            cell.delete.addGestureRecognizer(deleteGest)
            
            
            return cell
        }
        return Contact_Us_View()
    }
    
    
    
    
}


