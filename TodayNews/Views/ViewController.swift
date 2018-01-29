//
//  ViewController.swift
//  TodayNews
//
//  Created by Ron Rith on 1/14/18.
//  Copyright © 2018 Ron Rith. All rights reserved.
//

import UIKit
import SCLAlertView
import Kingfisher
import NVActivityIndicatorView


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NewsServiceDelegate,NVActivityIndicatorViewable {
    @IBOutlet var footerView: UIView!
    @IBOutlet var footerNavigationBar: UIActivityIndicatorView!
    
    @IBOutlet var todayNewsTableView: UITableView!
    
    var news: [News] = []
    var newsService = NewsService()
//    var pagination = Pagination()
    var pagination: Pagination = Pagination()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.newsService.delegate = self
        
        setUpView()
        getData(pageNumber: 1)
    }
    func getData(pageNumber: Int){
        if pageNumber == 1 {
            let size = CGSize(width: 30, height: 30)
            self.startAnimating(size, message: "Loading...", type: .ballBeat)
        }
        newsService.getData(pageNumber: pageNumber)
    }
    func setUpView(){
        self.todayNewsTableView.delegate = self
        self.todayNewsTableView.dataSource = self
        
        //register
        let nib = UINib.init(nibName: "TodayNewsTableViewCell", bundle: nil)
        todayNewsTableView.register(nib, forCellReuseIdentifier: "TodayNewsTableViewCell")

        todayNewsTableView.estimatedRowHeight = 120
        todayNewsTableView.rowHeight = UITableViewAutomaticDimension
        
        setUpRefresh()
        setUpNavigationBar()
    }
    func setUpRefresh(){
        // Add refresh control action
        self.todayNewsTableView.refreshControl?.attributedTitle = NSAttributedString(string: "Refreshing data...")
        self.todayNewsTableView.refreshControl?.tintColor = .red
        self.todayNewsTableView.refreshControl?.addTarget(self, action: #selector(handleRefresh(refreshControl:)), for: .valueChanged)
    }
    func setUpNavigationBar(){
        // Display LargeTitles
        if #available(iOS 11.0, *) {
            navigationController?.navigationBar.prefersLargeTitles = true
            navigationItem.largeTitleDisplayMode = .automatic
        }
    }
    func didResivedNews(with news: [News]?, pagination: Pagination?, error: Error?) {
        self.stopAnimating()
        // Check error
        if let err = error { SCLAlertView().showError("Error", subTitle: err.localizedDescription); return }
        setUpViewNewsData(news: news!)
        //self.pagination = JSON("page")
        self.pagination = pagination!
        
        todayNewsTableView.reloadData()
    }
    func setUpViewNewsData(news: [News]?){
        // if current == 1 means first request, else append data
        if self.pagination.page == 1 {
            self.news.removeAll()
            self.news = news!
        } else {
            self.news.append(contentsOf: news!)
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodayNewsTableViewCell") as! TodayNewsTableViewCell
        cell.configureCell(news: self.news[indexPath.row])

        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
         let newsIn = self.news[indexPath.row]
         performSegue(withIdentifier: "NewsDetailViewController", sender: newsIn)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //check segue
        if segue.identifier == "NewsDetailViewController"{
            let dest = segue.destination as! NewsDetailViewController
            dest.news2 = sender as! News
        }
    }
    
    // Refresh Control event
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        // Simply get data from first page which is latest data
        getData(pageNumber: 1)
    }
   
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print(" indexPath.row + 1 =\(indexPath.row + 1)")
        print(" Pagination.page =\(self.pagination.page)")
        print(" Pagination.totalPage =\(self.pagination.totalPages)")
        print(" Total Element = \(self.pagination.totalElements)")
        print(" self.news.count = \(self.news.count)")
        
        if indexPath.row + 1 >= self.news.count {
            // Current < total pages
            if self.pagination.page < self.pagination.totalPages {
                getData(pageNumber: (self.pagination.page + 1))
            }
        }
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }

}
