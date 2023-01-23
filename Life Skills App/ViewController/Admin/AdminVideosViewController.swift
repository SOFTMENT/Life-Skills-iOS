//
//  AdminVideosViewController.swift
//  RESET Life Skills App
//
//  Created by Vijay Rathore on 10/12/22.
//

import UIKit
import Firebase

class AdminVideosViewController : UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    
    var videoModels = Array<VideoModel>()
    override func viewDidLoad() {
        tableView.dataSource = self
        tableView.delegate = self

        //GETALLMUSICS
        getAllVideos()
    }
    func getAllVideos() {
        ProgressHUDShow(text: "")
        Firestore.firestore().collection("Videos").order(by: "title").addSnapshotListener { snapshot, error in
            self.ProgressHUDHide()
            if let error = error {
                self.showError(error.localizedDescription)
            }
            else {
                self.videoModels.removeAll()
                if let snapshot = snapshot, !snapshot.isEmpty {
                    for qdr in snapshot.documents {
                        if let videoModel = try? qdr.data(as: VideoModel.self) {
                            self.videoModels.append(videoModel)
                        }
                    }
                }
                
            
                
                self.tableView.reloadData()
            }
        }
    }
    @objc func videoDeleteCellClicked(value : MyGesture){
        let alert = UIAlertController(title: "DELETE", message: "Are you sure you want to delete this video?", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive,handler: { action in
            self.ProgressHUDShow(text: "Deleting...")
            Firestore.firestore().collection("Videos").document(value.id).delete { error in
                self.ProgressHUDHide()
                if let error = error {
                    self.showError(error.localizedDescription)
                }
                else {
                    self.showSnack(messages: "Video Deleted")
                }
            }
        }))
        
        present(alert, animated: true)
    }
    

    
    
    @IBAction func addVideoClicked(_ sender: Any) {
        performSegue(withIdentifier: "addVideoSeg", sender: nil)
    }
    
}

extension AdminVideosViewController : UITableViewDelegate , UITableViewDataSource {
    
    
  
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return videoModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "videocell", for: indexPath) as? VideosTableViewCell {
            
            cell.mImage.layer.cornerRadius = 12
        
            
            let videoModel = videoModels[indexPath.row]
            
            cell.mName.text = videoModel.title ?? "ERROR"
            cell.mDuration.text = "\(self.convertSecondstoMinAndSec(totalSeconds: videoModel.duration ?? 0)) min"
            
            cell.deleteView.isUserInteractionEnabled = true
            let myTap = MyGesture(target: self, action: #selector(videoDeleteCellClicked(value:)))
            myTap.id = videoModel.id ?? "123"
            cell.deleteView.addGestureRecognizer(myTap)
          
            if let thumbnail = videoModel.thumbnail, !thumbnail.isEmpty {
                cell.mImage.sd_setImage(with: URL(string: thumbnail), placeholderImage: UIImage(named: "placeholder"))
            }
            
            return cell
        }
        return VideosTableViewCell()
    }
    
    
    
    
}

