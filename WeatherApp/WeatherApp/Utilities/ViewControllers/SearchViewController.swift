//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by dedeepya reddy salla on 04/06/23.
//

import UIKit

let reuseIdentifier = "testCell"

class SearchViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var searchText: String = "" {
      didSet {
          updateSearchResults()
      }
    }
    
    var originalList: [String] = ["Monday", "Tuesday", "Wednesday", "Thursday"]
    var cell: UITableViewCell = UITableViewCell()
    private var searchList: [String] = []
   
    override func viewDidLoad() {
        super.viewDidLoad()
        searchList = originalList
        setUpUI()
    }
    
    func setUpUI() {
       
        let imageCell = "CurrentLocationCellTableViewCell"
        
        tableview.dataSource = self
        tableview.register(UINib(nibName: imageCell, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
       // tableview.register(CurrentLocationCellTableViewCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
    
    
    func updateSearchResults() {
        searchList = originalList.filter {$0.contains(searchText)}
        tableview.reloadData()
    }
}

extension SearchViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CurrentLocationCellTableViewCell
        return cell//configureCell(cell, searchList[indexPath.row])
    }
    
    func configureCell(_ cell: UITableViewCell, _ item: String) -> UITableViewCell {
        
        return cell
    }
    
}

class SearchTableViewDataSource<T: Any>: NSObject, UITableViewDataSource {
    
    var searchText: String = ""
    var originalList: [String]
    var cell: UITableViewCell = UITableViewCell()
    private var searchList: [String] = []
    
    init(originalList: [String]) {
        self.originalList = originalList
        searchList = originalList
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(forIndexPath: indexPath)
        //let cell = tableView.dequeueReusableCell(withIdentifier: "") ?? UITableViewCell()
        return configureCell(cell, searchList[indexPath.row])
    }
    
    func configureCell(_ cell: UITableViewCell, _ item: String) -> UITableViewCell {
        
        return cell
    }
    
    func updateSearchResults() {
        
        originalList.filter {$0.contains(searchText)}
    }
}
