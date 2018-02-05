//
//  SaveUpdateTableViewController.swift
//  TodayNews
//
//  Created by Ron Rith on 1/28/18.
//  Copyright © 2018 Ron Rith. All rights reserved.
//

import UIKit
import NVActivityIndicatorView
import SCLAlertView

class SaveUpdateTableViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate ,NewsServiceDelegate,NVActivityIndicatorViewable{
    // Property
    let imagePicker = UIImagePickerController()
    
    @IBOutlet var newsTitleTextField: UITextField!
    @IBOutlet var newsShortDescription: UITextField!
    
    @IBOutlet var newsDescriptionTextView: UITextView!
    @IBOutlet var newsImageView: UIImageView!
    @IBOutlet var saveUpdateNewNavigationBar: UINavigationItem!
    
    var newsService = NewsService()
    var newHolder : News?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let newsData = newHolder{
            newsTitleTextField.text = newsData.name
            newsShortDescription.text = newsData.dec
            newsDescriptionTextView.text = newsData.desEn
            newsImageView.kf.setImage(with: URL(string: newsData.realImageUrl), placeholder: #imageLiteral(resourceName: "noimage_thumbnail"))
        }
        setUpView()
    }
    func setUpView(){
        newsService.delegate = self
        imagePicker.delegate = self
        
        setupNavigationBar()
        setupViewCornerRadius(view: newsImageView)
        setupViewCornerRadius(view: newsDescriptionTextView)
    }
    
    func setupViewCornerRadius(view: UIView) {	
        
        let layer = view.layer
        // Corner
        layer.cornerRadius = 5
        layer.masksToBounds = true
        
        // Border
        layer.borderColor = #colorLiteral(red: 0.06274510175, green: 0, blue: 0.1921568662, alpha: 1)
        layer.borderWidth = 1
    }

    func setupNavigationBar() {
        if #available(iOS 11.0, *) {
            saveUpdateNewNavigationBar.largeTitleDisplayMode = .never
        }
        
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
    }
    
    @IBAction func browsNewsImage(_ sender: Any) {
        print(#function)
        imagePicker.allowsEditing = false // or true
        imagePicker.sourceType = .photoLibrary // or .camera
//        imagePicker.mediaTypes = [kUTTypeImage as String] or [kUTTypeMovie as String] or [kUTTypeImage as String, kUTTypeMovie as String]
        present(imagePicker, animated: true, completion: nil)
    }
    // view image in news view
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(#function)
                                                                                                
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            newsImageView.contentMode = .scaleAspectFit
            newsImageView.image = pickedImage
            //test upload method
            //testUpload()
        }
        let imageURL = info[UIImagePickerControllerReferenceURL] as! NSURL
        let fileName = imageURL.absoluteString
        
        print("File Name: \(fileName!)")
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        dismiss(animated: true, completion: nil)
    }
    @IBAction func backToMain(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func SaveNewsData(_ sender: Any) {
        // Create NAActivityIndicator
//        self.startAnimating(message: "Loading...")
        print("Start Function Save \(#function)")
        // Read Image
        let imageData = UIImageJPEGRepresentation(self.newsImageView.image!, 1)
        print("imageData: \(imageData!)")
        newsService.uploadFile(file: imageData!) { (imageUrl, error) in
            // Check error
            if let err = error { SCLAlertView().showError("Error", subTitle: err.localizedDescription); return }
            
            // Request paramaters
            let paramaters = [
                "name": self.newsTitleTextField.text!,
                "dec": self.newsShortDescription.text!,
                "desEn": self.newsDescriptionTextView.text!,
                "objectStatus": true,
                "realImageUrl": imageUrl ?? ""
                ] as [String : Any]
            
            // if have news data > update
            if let news = self.newHolder {
                // Update code
                print("news: update\(news)")
                self.newsService.updateNews(with: "\(news.id)", parameters: paramaters)
            }else {
                 print("news: save")
                // Add news
                 self.newsService.saveNews(paramaters: paramaters)
            }
           
        }
       print("End Function Save \(#function)")
    }
    
    func saveNews(error: Error?) {
        print("Add article response")
        stopAnimating()
        // Check error
        if let err = error { SCLAlertView().showError("Error", subTitle: err.localizedDescription); return }
        
        self.navigationController?.popViewController(animated: true)
    }
}
