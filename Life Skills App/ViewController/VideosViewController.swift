//
//  VideosViewController.swift
//  RESET Life Skills App
//
//  Created by Vijay Rathore on 09/12/22.
//

import UIKit
import Firebase
import AVFoundation
import AVKit

class VideosViewController : UIViewController {
    
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
    @objc func videocCellClicked(value : MyGesture){
      
        
        let player = AVPlayer(url: URL(string: self.videoModels[value.index].videoUrl ?? "")!)
        let vc = AVPlayerViewController()
        vc.player = player

        present(vc, animated: true) {
            vc.player?.play()
        }
    }
    
}

extension VideosViewController : UITableViewDelegate , UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return videoModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "videocell", for: indexPath) as? VideosTableViewCell {
            
            cell.mImage.layer.cornerRadius = 12
        
            
            let videoModel = videoModels[indexPath.row]
            
            cell.mName.text = videoModel.title ?? "ERROR"
            cell.mDuration.text = "\(self.convertSecondstoMinAndSec(totalSeconds: videoModel.duration ?? 0)) min"
            
            cell.mView.isUserInteractionEnabled = true
            let myTap = MyGesture(target: self, action: #selector(videocCellClicked(value:)))
            myTap.index = indexPath.row
            cell.mView.addGestureRecognizer(myTap)
          
            if let thumbnail = videoModel.thumbnail, !thumbnail.isEmpty {
                cell.mImage.sd_setImage(with: URL(string: thumbnail), placeholderImage: UIImage(named: "placeholder"))
            }
            
            return cell
        }
        return VideosTableViewCell()
    }
    
    
    
    
}

