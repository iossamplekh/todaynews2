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
import SwiftyJSON

class SaveUpdateTableViewController: UITableViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate ,NewsServiceDelegate,NVActivityIndicatorViewable,UIPickerViewDelegate,UIPickerViewDataSource{
    
    // Property
    let imagePicker = UIImagePickerController()
    
    @IBOutlet var newsTitleTextField: UITextField!
    @IBOutlet var newsShortDescription: UITextField!
    
    @IBOutlet var newsDescriptionTextView: UITextView!
    @IBOutlet var newsImageView: UIImageView!
    @IBOutlet var saveUpdateNewNavigationBar: UINavigationItem!
    
    @IBOutlet var newsTypeAuthorPickerView: UIPickerView!
    
    var newsService = NewsService()
    var newsTypeValue: String = "Sport"
    var authorEmailValue: String = "author1@gmail.com"
    
    var jsonDictHolder: [String: Any]?
    var newsType: [NewsType] = []
    var authors: [Author] = []
    
    var data: [[String]] = [[String]]()
    var arrn: [String] = [String]()
    var arra: [String] = [String]()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        newsService.delegate = self
        newsTypeAuthorPickerView.delegate = self
        newsTypeAuthorPickerView.dataSource = self
        imagePicker.delegate = self
        
       if let newsData = jsonDictHolder {
        print("********view did load*********")
        print("NEWSDATA: \(newsData)")
        for (key,value) in newsData{
            print("KEY: \(key); VALUE: \(value)")
            if(key == "newsObj"){
                var nob: News?
                nob = value as! News

                newsTitleTextField.text = nob?.name ?? ""
                newsShortDescription.text = nob?.dec ?? ""
                newsDescriptionTextView.text = nob?.desEn ?? ""
                let url = "https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Angkor_Wat.jpg/1280px-Angkor_Wat.jpg"
                newsImageView.downloadImageWith(urlString: url, completion: {
                        self.newsImageView.image
                })
                newsImageView.clipsToBounds = true
         
            }else if(key == "newsTypes"){
                self.newsType = value as! [NewsType]
                print("self.newsType: \(self.newsType)")
            } else if(key == "authors"){
                self.authors = value as! [Author]
                print("self.authors: \(self.authors)")
            }
        }
        
        for nwi in self.newsType {
            arrn.append(nwi.desEn)
        }
        for ath in self.authors{
            arra.append(ath.email)
        }
        
        self.data = [
            arrn,
            arra
        ]
        
       }
       
        setUpView()
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        print("(numberOfComponents) self.data.count.count = \(self.data.count)")
        return self.data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.data[component].count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(data[component][row])"
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("Selected Row: \(row) Component: \(component)")
        print("\(data[component][row])")
        if component == 0 {
            self.newsTypeValue = data[component][row]
        }else if component == 1{
            self.authorEmailValue = data[component][row]
        }
    }

    
//    func getAllNewsType(){
//        getNewsTypeData()
//    }
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
            
            if let news = self.jsonDictHolder {
                for (key,value) in news{
                    print("KEY: \(key); VALUE: \(value)")
                    if(key == "newsObj"){
                        var nob: News?
                        nob = value as! News
                        let nob_id = nob?.id as! Int
                        self.newsService.updateNews(with: self.newsTypeValue, with: "rithronlkh@gmail.com", with: self.authorEmailValue,with: "\(nob_id)", parameters: paramaters)
                    }else if(key == "newsTypes"){
                        self.newsType = value as! [NewsType]
                    } else if(key == "authors"){
                        self.authors = value as! [Author]
                    }
                }
            }else {
                print("news: save")
                self.newsService.saveNews(with: self.newsTypeValue, with: "rithronlkh@gmail.com", with: self.authorEmailValue, paramaters: paramaters)
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
    override func viewDidAppear(_ animated: Bool) {
        print("viewdidappear*****")
        print("viewdidappear news type: \(self.newsType)")
        print("viewdidappear authors: \(self.authors)")
    }
}
