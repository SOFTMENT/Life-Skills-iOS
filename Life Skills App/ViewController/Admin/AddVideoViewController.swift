//
//  AddVideoViewController.swift
//  RESET Life Skills App
//
//  Created by Vijay Rathore on 10/12/22.
//

import UIKit
import CropViewController
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import MobileCoreServices
import UniformTypeIdentifiers
import AVFoundation

class AddVideoViewController : UIViewController {
    
    
    @IBOutlet weak var imageView: UIView!
    @IBOutlet weak var musicImage: UIImageView!
    @IBOutlet weak var addMusicView: UIView!
    
    @IBOutlet weak var musicNameTF: UITextField!
   
    
    @IBOutlet weak var addBtn: UIButton!
    
    

    var isImageSelected = false
    var videoPath : URL?
   
    @IBOutlet weak var addMusicLabel: UILabel!
    
    
    override func viewDidLoad() {
        
        
      
        addBtn.layer.cornerRadius = 12
        
        addMusicView.isUserInteractionEnabled = true
        addMusicView.layer.borderWidth = 1
        addMusicView.addBorder()
        addMusicView.layer.cornerRadius = 8
        addMusicView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(addMusicClicked)))
        
        musicNameTF.setLeftPaddingPoints(10)
        musicNameTF.setRightPaddingPoints(10)
        musicNameTF.changePlaceholderColour()
        musicNameTF.layer.cornerRadius = 8
        musicNameTF.addBorder()

        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius = 12
        imageView.addBorder()
        imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewClicked)))
        
        musicImage.isUserInteractionEnabled = true
        musicImage.layer.cornerRadius = 12
        musicImage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imageViewClicked)))
    
        
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))
        
    }
    
    @IBAction func backBtnClicked(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    
    
    @objc func hideKeyboard(){
        view.endEditing(true)
    }
    
    @objc func addMusicClicked(){
        

        let image = UIImagePickerController()
        image.delegate = self
        image.title = title
        image.mediaTypes = ["public.movie"]
        image.sourceType = .photoLibrary
        self.present(image,animated: true)
    }
    
    @objc func imageViewClicked(){
        chooseImageFromPhotoLibrary()
    }
    
    func chooseImageFromPhotoLibrary(){
        
        let image = UIImagePickerController()
        image.delegate = self
        image.title = title
        
        image.sourceType = .photoLibrary
        self.present(image,animated: true)
    }
    
    @objc func backViewClicked(){
        self.dismiss(animated: true)
    }
    
    @IBAction func addBtnClicked(_ sender: Any) {
        Task { @MainActor in
            
            let sTitle = self.musicNameTF.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    
            
            if !isImageSelected {
                self.showSnack(messages: "Upload Image")
            }
            else if self.videoPath == nil {
                self.showSnack(messages: "Add Video")
            }
            else if sTitle!.isEmpty {
                self.showSnack(messages: "Enter Title")
            }
        
            else {
              
                let musicId = Firestore.firestore().collection("Videos").document().documentID
                let musicModel = VideoModel()
                musicModel.id = musicId
                musicModel.duration = await Int(self.getVideoDuration())
                musicModel.title = sTitle ?? ""
                musicModel.createdDate = Date()
                self.ProgressHUDShow(text: "Uploading Video")
                self.uploadMusicOnFirebase(musicId: musicId) { downloadURL in
                    self.ProgressHUDHide()
                    if !downloadURL.isEmpty {
                        musicModel.videoUrl = downloadURL
                        self.ProgressHUDShow(text: "")
                        self.uploadImageOnFirebase(musicId: musicId) { downloadURL in
                            self.ProgressHUDHide()
                            if !downloadURL.isEmpty {
                                musicModel.thumbnail = downloadURL
                                self.uploadMusicModelOnFirebase(musicModel: musicModel)
                                
                            }
                            
                            
                        }
                    }
                }
                
                
                
                
            }
        }
    }
    
}

extension AddVideoViewController : UIImagePickerControllerDelegate,UINavigationControllerDelegate,CropViewControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[.originalImage] as? UIImage {
            
            self.dismiss(animated: true) {
                
                let cropViewController = CropViewController(image: editedImage)
                cropViewController.title = picker.title
                cropViewController.delegate = self
                cropViewController.customAspectRatio = CGSize(width: 1  , height: 1)
                cropViewController.aspectRatioLockEnabled = true
                cropViewController.aspectRatioPickerButtonHidden = true
                self.present(cropViewController, animated: true, completion: nil)
            }
            
        }
        else {
            
            self.dismiss(animated: true) {
                self.videoPath = info[UIImagePickerController.InfoKey(rawValue: UIImagePickerController.InfoKey.mediaURL.rawValue)] as? URL
                self.addMusicLabel.text  = "Video Added"
                self.addMusicView.layer.backgroundColor = UIColor(red: 152/255, green: 198/255, blue: 106/255, alpha: 1).cgColor
            }
          
         
        }
        
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
        
        isImageSelected = true
        musicImage.image = image
        musicImage.isHidden = false
        imageView.isHidden = true
        self.dismiss(animated: true, completion: nil)
    }
    
    
    func uploadImageOnFirebase(musicId : String,completion : @escaping (String) -> Void ) {
        var downloadUrl = ""
        
        
        let storage = Storage.storage().reference().child("VideoImages").child(musicId).child("\(musicId).png")
        
        
        var uploadData : Data!
        
        uploadData = (self.musicImage.image?.jpegData(compressionQuality: 0.4))!
        
        
        
        storage.putData(uploadData, metadata: nil) { (metadata, error) in
            
            if error == nil {
                storage.downloadURL { (url, error) in
                    if error == nil {
                        downloadUrl = url!.absoluteString
                    }
                    completion(downloadUrl)
                    
                }
            }
            else {
                completion(downloadUrl)
            }
            
        }
    }
    
    func getVideoDuration() async -> Double{
        let avplayeritem = AVPlayerItem(url: videoPath! as URL)
        
        let totalSeconds = try? await avplayeritem.asset.load(.duration).seconds
        return totalSeconds ?? 0
    }
    
    func uploadMusicModelOnFirebase(musicModel : VideoModel){
        ProgressHUDShow(text: "")
        try? Firestore.firestore().collection("Videos").document(musicModel.id ?? "123").setData(from: musicModel) { error in
            self.ProgressHUDHide()
            if let error = error {
                self.showError(error.localizedDescription)
            }
            else {
                self.showSnack(messages: "Music Added")
                
         
          
                    self.dismiss(animated: true)
                   
               
                
            }
        }
    }
    func uploadMusicOnFirebase(musicId : String,completion : @escaping (String) -> Void ) {
        var downloadUrl = ""
        
        
        let storage = Storage.storage().reference().child("Videos").child(musicId).child("\(musicId).mp4")
        
        
        let metadata = StorageMetadata()
        //specify MIME type
        
        metadata.contentType = "video/mp4"
        
        if let musicData = try? NSData(contentsOf: videoPath!, options: .mappedIfSafe) as Data {
            
            storage.putData(musicData, metadata: metadata) { metadata, error in
                
                if error == nil {
                    storage.downloadURL { (url, error) in
                        if error == nil {
                            downloadUrl = url!.absoluteString
                        }
                        completion(downloadUrl)
                        
                    }
                }
                else {
                    print(error!.localizedDescription)
                    completion(downloadUrl)
                }
            }
        }
        else {
            completion(downloadUrl)
            self.showSnack(messages: "ERROR")
        }
    }
}

extension AddVideoViewController : UITextFieldDelegate, UITextViewDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return true
    }
    
}

