//
//  LocationSearchViewController.swift
//  WeatherApp
//
//  Created by dedeepya reddy salla on 04/06/23.
//

import UIKit

class LocationSearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        uiSetUp()
        // Do any additional setup after loading the view.
    }
    

    func uiSetUp() {
        tableView.dataSource = self
//        tableView.register(UINib(nibName: imageCell, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
       // tableView.register(ImageCell.self, forCellReuseIdentifier: reuseIdentifier)
    }
}

extension LocationSearchViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.largeContentTitle = "testing"
//        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! ImageCell
//        cell.bigImageView.image = UIImage(named: "Flower.jpeg") //UIImageView(image: UIImage(named: "Flower"))
//        cell.iconImageView.image = UIImage(named: "Flower.jpeg")//UIImageView(image: UIImage(named: "Flower"))
//        cell.descriptionLabel.text = "keep one line for now"
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
}
