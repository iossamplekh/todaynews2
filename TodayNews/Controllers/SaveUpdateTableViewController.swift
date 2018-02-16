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

class SaveUpdateTableViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate ,NewsServiceDelegate,NVActivityIndicatorViewable,NewsTypeServiceDelegate,UIPickerViewDelegate,UIPickerViewDataSource{
    
    // Property
    let imagePicker = UIImagePickerController()
    
    @IBOutlet var newsTitleTextField: UITextField!
    @IBOutlet var newsShortDescription: UITextField!
    
    @IBOutlet var newsDescriptionTextView: UITextView!
    @IBOutlet var newsImageView: UIImageView!
    @IBOutlet var saveUpdateNewNavigationBar: UINavigationItem!
    
    @IBOutlet var newsTypeAuthorPickerView: UIPickerView!
    
    var newsService = NewsService()
    var newsTypeService = NewsTypeService()
    
    var newHolder : News?
    var newsType: [NewsType] = []
    
    var data: [[Any]] = [[Any]]()
    var pickerString = NSArray() as AnyObject as! [String]
    
    func didResivedNewsType(with newsType: [NewsType]?, error: Error?) {
        self.newsType = newsType!
        var count = 0
        if newsType != nil {
            for ns in self.newsType {
                data.append([ns.desEn])
                count = count + 1
                print("====ns.desEn==== \(ns.desEn)")
            }
        }
        print("---newsTypenewsTypenewsTypenewsTypenewsTypenewsType---")
        print("SHOW ARRAY OF NEWS TYPE: \(self.newsType)")
        print("data: \(data)")
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        newsService.delegate = self
        newsTypeService.delegate = self
        newsTypeAuthorPickerView.delegate = self
        newsTypeAuthorPickerView.dataSource = self
        imagePicker.delegate = self
        
        getAllNewsType()
        
        if let newsData = newHolder{
            newsTitleTextField.text = newsData.name
            newsShortDescription.text = newsData.dec
            newsDescriptionTextView.text = newsData.desEn
            print("NEWS ID: \(newsData.id)")
            //newsImageView.kf.setImage(with: URL(string: newsData.realImageUrl), placeholder: #imageLiteral(resourceName: "noimage_thumbnail"))
            let url = "https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Angkor_Wat.jpg/1280px-Angkor_Wat.jpg"
            newsImageView.downloadImageWith(urlString: url, completion: {
               self.newsImageView.image
            })
            newsImageView.clipsToBounds = true
        }
        setUpView()
        print("VIEW DID LOAD ")
        print("data: \(data)")
//        data = [
//            ["January", "February", "March"],
//            [1990, 1991, 1992]
//        ]
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        print("(numberOfComponents) self.newsType.count = \(self.newsType.count)")
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "Hello"
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("---viewWillAppearviewWillAppearviewWillAppearviewWillAppearv----")
        print("SHOW ARRAY OF NEWS TYPE: \(self.newsType)")
        print("data: \(data)")
    }
    
    func getAllNewsType(){
        getNewsTypeData()
    }
    func setUpView(){
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
    
    func testUpload(){
        if let imageData = UIImageJPEGRepresentation(self.newsImageView.image!, 1){
            print("imageData: \(imageData)")
            newsService.uploadFile(file: imageData) { (imageUrl, error) in
                // Check error
                if let err = error { SCLAlertView().showError("Error", subTitle: err.localizedDescription); return }
                print("imageUrl: \(imageUrl!)")
            }
        }
    }
    
    func testUploadDev(){
        if let imageData = UIImageJPEGRepresentation(self.newsImageView.image!, 0.1){
            print("imageData: \(imageData)")	
            newsService.uploadFile(file: imageData) { (imageUrl, error) in
                // Check error
                if let err = error { SCLAlertView().showError("Error", subTitle: err.localizedDescription); return }
                print("imageUrl: \(imageUrl!)")
            }
        }
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
        print("Start Function Save \(#function)")
        // Read Image
        let imageData = UIImageJPEGRepresentation(self.newsImageView.image!, 1)
        print("imageData: \(imageData!)")
        newsService.uploadFile(file: imageData!) { (imageUrl, error) in
            // Check error
            if let err = error { SCLAlertView().showError("Error", subTitle: err.localizedDescription); return }
            let paramaters = [
                "name": self.newsTitleTextField.text!,
                "dec": self.newsShortDescription.text!,
                "desEn": self.newsDescriptionTextView.text!,
                "objectStatus": true,
                "realImageUrl": imageUrl ?? ""
                ] as [String : Any]
            
            if let news = self.newHolder {
                print("news: update\(news)")
                print("news id:\(news.id)")
                self.newsService.updateNews(with: "\(news.id)", parameters: paramaters)
            }else {
                 print("news: save")
                 self.newsService.saveNews(paramaters: paramaters)
            }
        }
       print("End Function Save \(#function)")
    }
    
    func didUpdateNews(error: Error?) {
        stopAnimating()
        if let err = error { SCLAlertView().showError("Error", subTitle: err.localizedDescription); return }
        
        self.navigationController?.popViewController(animated: true)
    }
    func SaveNews(error: Error?) {
        stopAnimating()
        if let err = error { SCLAlertView().showError("Error", subTitle: err.localizedDescription); return }
        
        self.navigationController?.popViewController(animated: true)
    }
    
    func getNewsTypeData(){
        self.newsTypeService.getNewsTypeData()
    }
}
