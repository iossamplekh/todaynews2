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
import SwiftyJSON


class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,NewsServiceDelegate,NVActivityIndicatorViewable {
    @IBOutlet var footerView: UIView!
    @IBOutlet var footerNavigationBar: UIActivityIndicatorView!
    
    @IBOutlet var todayNewsTableView: UITableView!
    
    var news: [News] = []
    var newsService = NewsService()
    
    var newsType: [NewsType] = []
    var authors: [Author] = []
    
    var pagination: Pagination = Pagination()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getAllDataCrossSreen()
        
        self.newsService.delegate = self
        self.todayNewsTableView.delegate = self
        self.todayNewsTableView.dataSource = self
        
        setUpRefresh()
        setUpView()
        getData(pageNumber: 1)

        //print("USER ID: \(UserDefaults.standard.string(forKey: "userID"))")
    }
    func getData(pageNumber: Int){
        if pageNumber == 1 {
            let size = CGSize(width: 30, height: 30)
            self.startAnimating(size, message: "Loading...", type: .ballBeat)
        }
        newsService.getData(pageNumber: pageNumber)
    }
    func setUpView(){
        let nib = UINib.init(nibName: "TodayNewsTableViewCell", bundle: nil)
        todayNewsTableView.register(nib, forCellReuseIdentifier: "TodayNewsTableViewCell")

        // TableViewSectionHeader
//        let nib2 = UINib(nibName: "TableViewSectionHeader", bundle: nil)
//        todayNewsTableView.register(nib2, forHeaderFooterViewReuseIdentifier: "TableViewSectionHeaderIdentifier") // register and set identifier
        //todayNewsTableView.estimatedSectionHeaderHeight = UITableViewAutomaticDimension
        //todayNewsTableView.sectionHeaderHeight = UITableViewAutomaticDimension
        
        todayNewsTableView.estimatedRowHeight = 120
        todayNewsTableView.rowHeight = UITableViewAutomaticDimension
        
        
        
        //setUpRefresh()
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
        self.todayNewsTableView.refreshControl?.endRefreshing()
        // Check error
        if let err = error { SCLAlertView().showError("Error", subTitle: err.localizedDescription); return }
         self.pagination = pagination!
        // if current == 1 means first request, else append data
        if self.pagination.page == 1 {
            self.news.removeAll()
            self.news = news!
        } else {
            self.news.append(contentsOf: news!)
        }
        self.todayNewsTableView.reloadData()
    }
    func setUpViewNewsData(news: [News]?){
        // if current == 1 means first request, else append data
        if self.pagination.page == 1 {
            self.news.removeAll()
            self.news = news!
        } else {
            self.news.append(contentsOf: news!)
        }
        todayNewsTableView.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.news.count
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("==========================================")
        print(" indexPath.row + 1 =\(indexPath.row + 1)")
        print(" Pagination.page =\(self.pagination.page)")
        print(" Pagination.totalPage =\(self.pagination.totalPages)")
        print(" Total Element = \(self.pagination.totalElements)")
        print(" self.news.count = \(self.news.count)")
        print(" self.pagination.totalPages = \(self.pagination.totalPages)")
        
        if indexPath.row + 1 >= self.news.count {
            // Current < total pages
            if self.pagination.page <= self.pagination.totalPages {
                let numpage = self.pagination.page + 1
                getData(pageNumber: numpage)
            }
        }
    }
//    override func viewDidAppear(_ animated: Bool) {
//        getData(pageNumber: 1)
//    }
    override func viewWillAppear(_ animated: Bool) {
        //self.todayNewsTableView.reloadData()
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
        if segue.identifier == "showEdit" {
            print("************************************")
            print("prepare news type: \(self.newsType)")
            print("prepare authors: \(self.authors)")
            print("************************************")
            let destView = segue.destination as! SaveUpdateTableViewController
<<<<<<< HEAD
                let jsonDict = [
                    "newsObj" : sender as! News,
                    "newsTypes" : self.newsType,
                    "authors" : self.authors
                    ] as [String : Any]
                print("jsonDict: \(jsonDict)")
                destView.jsonDictHolder = jsonDict as! [String : Any]
=======
        
            let jsonDict = [
                "newsObj" : sender as! News,
                "newsTypes" : self.newsType,
                "authors" : self.authors
                ] as [String : Any]
            print("jsonDict: \(jsonDict)")
            destView.jsonDictHolder = jsonDict as! [String : Any]
           
        }
        if segue.identifier == "toSave" {
            print("************************************")
            print("prepare news type: \(self.newsType)")
            print("prepare authors: \(self.authors)")
            print("************************************")
            let destView = segue.destination as! SaveUpdateTableViewController
            
            let jsonDict = [
                "newsObj" : sender as! News,
                "newsTypes" : self.newsType,
                "authors" : self.authors
                ] as [String : Any]
            print("jsonDict: \(jsonDict)")
            destView.jsonDictHolder = jsonDict as! [String : Any]
            
>>>>>>> 345d1c92d09c4772890f6d19e9213e7f4ba76da2
        }
    }
    
    // Refresh Control event
    @objc func handleRefresh(refreshControl: UIRefreshControl) {
        // Simply get data from first page which is latest data
        getData(pageNumber: 1)
    }
   
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        //delete news
        let delete = UITableViewRowAction(style: .destructive, title: "Delete") { action, index in
            
            let appearance = SCLAlertView.SCLAppearance(
                showCloseButton: false
            )
            let alertWarning = SCLAlertView(appearance: appearance)
            
            alertWarning.addButton("OK", action: {
                
                self.startAnimating()
                let news = self.news[indexPath.row]
                self.newsService.deleteNews(with: "\(news.id)", completion: { (error) in
                  
                    self.stopAnimating()
                    if let err = error { SCLAlertView().showError("Error", subTitle: err.localizedDescription); return }
                    
                    tableView.beginUpdates()
                    self.news.remove(at: indexPath.row)
                    tableView.deleteRows(at: [indexPath], with: .fade)
                    tableView.endUpdates()
                })
            })
            alertWarning.showWait("Delete News", subTitle: "Do you want to delete this news?")
        }
        // Edit News Button
        let edit = UITableViewRowAction(style: .default, title: "Edit") { action, index in
            let news = self.news[indexPath.row]
            self.performSegue(withIdentifier: "showEdit", sender: news)
        }
        
        edit.backgroundColor = UIColor.brown
        return [delete, edit]
    }
    
    @IBAction func logout(_ sender: Any) {
        let storybaord = UIStoryboard(name: "SingInAndSignUp", bundle: nil)
        let vc = storybaord.instantiateInitialViewController()
        self.present(vc!, animated: true, completion: nil)
        UserDefaults.standard.removeObject(forKey: "UserID")
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func toAdd(_ sender: Any) {
//        let newViewController = SaveUpdateTableViewController()
//        self.navigationController?.pushViewController(newViewController, animated: true)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "showEdit") as! SaveUpdateTableViewController
        self.present(newViewController, animated: true, completion: nil)
    }
    @IBAction func toRefresh(_ sender: Any) {
        getData(pageNumber: 1)
    }
    func getAllDataCrossSreen(){
        NewsTypeAndAuthorService.shared.getAllNewsTypeAndAuthor { (response, error) in
            if let err = error { SCLAlertView().showError("Error", subTitle: err.localizedDescription); return }
            if let value = response?.result.value {
                let json = JSON(value)
                
                if let code = json["code"].int, code == 2222 {
                    print("Get news type Success")
                    let newst =  json["object"]["newstypes"].arrayValue.map{ NewsType($0) }
                    self.newsType = newst
                    
                    let author =  json["object"]["authors"].arrayValue.map{ Author($0) }
                    self.authors = author
            
                    print("share newst : \(newst)")
                    print("share self.newsType : \(self.newsType)")
                    print("share author : \(author)")
                    print("share self.authors : \(self.authors)")
                    
                    //SCLAlertView().showInfo("Welcome", subTitle: "Get newstype Success!")
                    
                }else { // error
                    SCLAlertView().showError("Error \(String(describing: json["code"].int!))", subTitle: json["message"].stringValue); return
                }
            }else {
                SCLAlertView().showError("Error", subTitle: "Server error");
                return
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("viewdidappear*****")
        print("viewdidappear news type: \(self.newsType)")
        print("viewdidappear authors: \(self.authors)")
    }
    
    @IBAction func toSave(_ sender: Any) {
//        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
//
//        let secondViewController = storyBoard.instantiateInitialViewController() as! UINavigationController
//        self.present(secondViewController, animated:true, completion:nil)
        // Check if value from myTextField is not empty
    
        // Instantiate SecondViewController
        let secondViewController = self.storyboard?.instantiateViewController(withIdentifier: "showEdit") as! SaveUpdateTableViewController
     
        self.navigationController?.pushViewController(secondViewController, animated: true)
    }
    
}
