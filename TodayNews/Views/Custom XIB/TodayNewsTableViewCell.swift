//
//  TodayNewsTableViewCell.swift
//  TodayNews
//
//  Created by Ron Rith on 1/14/18.
//  Copyright © 2018 Ron Rith. All rights reserved.
//

import UIKit
import Kingfisher

class TodayNewsTableViewCell: UITableViewCell {

    @IBOutlet var newsNameLabel: UILabel!
    @IBOutlet var newsTypeLable: UILabel!
    @IBOutlet var newsImageView: UIImageView!
    
    @IBOutlet weak var indicatorView: UIView!
    @IBOutlet weak var newsIndicatorPlay: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func configureCell(news: News) {
        // Set data to control
        newsNameLabel.text = news.name ?? "Unknown"
        newsTypeLable.text = "Category: \(news.newsType.desEn)" ?? "unknown"
        newsImageView.loadImageUsingUrlString(urlString: news.realImageUrl)
        print("Here is image url \(news.image)")
           //newsImageView.kf.setImage(with: URL(string: news.realImageUrl))
    }
    

    
}
