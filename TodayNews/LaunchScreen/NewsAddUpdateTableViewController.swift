//
//  NewsAddUpdateTableViewController.swift
//  TodayNews
//
//  Created by Ron Rith on 1/24/18.
//  Copyright © 2018 Ron Rith. All rights reserved.
//

import UIKit

class NewsAddUpdateTableViewController: UITableViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    @IBOutlet var newsTitleTextField: UITextField!
    @IBOutlet var newsNameTextField: UITextField!
    @IBOutlet var newsDescriptionTextView: UITextView!
    @IBOutlet var newsImageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupControll()
        imagePicker.delegate = self
    }
    func setupControll(){
        setupViewCornerRadius(view: newsTitleTextField)
        setupViewCornerRadius(view: newsNameTextField)
        setupViewCornerRadius(view: newsDescriptionTextView)
        setupNavigationBar()
    }
    func setupNavigationBar(){
        // Display LargeTitles
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .never
        }
    }
    func setupViewCornerRadius(view: UIView){
        let customView = view.layer
        //corner
        customView.cornerRadius = 5
        customView.masksToBounds = true
        //border
        customView.borderColor = #colorLiteral(red: 0.004859850742, green: 0.09608627111, blue: 0.5749928951, alpha: 1)
        customView.borderWidth = 1
    }
    @IBAction func BacktoMainMenu(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func browseImage(_ sender: Any) {
        print(#function)
        imagePicker.allowsEditing = false // or true
        imagePicker.sourceType = .photoLibrary // or .camera
        // imagePicker.mediaTypes = [kUTTypeImage as String] or [kUTTypeMovie as String] or [kUTTypeImage as String, kUTTypeMovie as String]
        present(imagePicker, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        print(#function)
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
            newsImageView.contentMode = .scaleAspectFit
            newsImageView.image = pickedImage
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        dismiss(animated: true, completion: nil)
    }
}
