//
//  NewsDetailViewController.swift
//  TodayNews
//
//  Created by Ron Rith on 1/17/18.
//  Copyright © 2018 Ron Rith. All rights reserved.
//

import UIKit

class NewsDetailViewController: UIViewController {
    //outlet
    @IBOutlet var newsImageView: UIImageView!
    @IBOutlet var newsNameLable: UILabel!
    @IBOutlet var newsTypeLable: UILabel!
    @IBOutlet var newsDescription: UILabel!
    @IBOutlet var imageHeightConstrant: NSLayoutConstraint!
    
    // data holder
    var mealHolder: [String:String] = [:]
    var news: [News] = []
    var news2: News?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }
    
    
    func setUpView(){
        print(mealHolder)
        
        newsNameLable.text = news2!.name
        newsTypeLable.text = news2!.newsType.desEn
            newsDescription.text = news2!.desEn
            self.title = news2!.name
        
           let url = "https://upload.wikimedia.org/wikipedia/commons/thumb/4/41/Angkor_Wat.jpg/1280px-Angkor_Wat.jpg"
            newsImageView.downloadImageWith(urlString: url, completion: {
                if let image = self.newsImageView.image {
                    // Calculate aspect
                    let aspect = image.size.height / image.size.width
                    
                    self.imageHeightConstrant.constant = self.view.frame.size.width * aspect
                }
            })
             newsImageView.clipsToBounds = true
        // Display LargeTitles
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .never
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        // Calculate aspect
        let aspect = (newsImageView.image?.size.height ?? 0.0) / (newsImageView.image?.size.width ?? 0.0)
        
        imageHeightConstrant.constant = view.frame.size.width * aspect
    }


}
