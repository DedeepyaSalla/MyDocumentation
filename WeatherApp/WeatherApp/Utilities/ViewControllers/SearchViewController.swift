//
//  SearchViewController.swift
//  WeatherApp
//
//  Created by dedeepya reddy salla on 04/06/23.
//

import UIKit

let reuseIdentifier = "CityTableViewCellReuse"

protocol SearchVCProtocol: AnyObject {
    func selectedItem(item: String)
}

class SearchViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableview: UITableView!
    
    // MARK: - properties
    private var searchList: [String] = []
    var originalList: [String] = []
    var searchText: String = "" {
      didSet {
          updateSearchResults()
      }
    }
    weak var delegate: SearchVCProtocol?

    // MARK: - UI setup
    override func viewDidLoad() {
        super.viewDidLoad()
        searchList = originalList
        setUpUI()
        
        print("initialized search vc")
        print(originalList.count)
        print(searchList.count)
    }
    
    func setUpUI() {
        let imageCell = "CityTableViewCell"
        tableview.dataSource = self
        tableview.delegate = self
        tableview.register(UINib(nibName: imageCell, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
    }

    func updateSearchResults() {
        searchList = originalList.filter {$0.contains(searchText)}
        tableview.reloadData()
        
        print("searching udpate", searchText)
        print(originalList.count)
        print(searchList.count)
    }
}

// MARK: - UITableViewDataSource, UITableViewDelegate
extension SearchViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("came to cell")
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! CityTableViewCell
        cell.cityLabel.text = searchList[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.selectedItem(item: searchList[indexPath.row])
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
