//
//  CurrentLocationCellTableViewCell.swift
//  WeatherApp
//
//  Created by dedeepya reddy salla on 04/06/23.
//

import UIKit

class CurrentLocationCellTableViewCell: UITableViewCell {

    var testingValue = "testing"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        print("awake from nib -- CurrentLocationCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}

class BaseTableViewCell<V>: UITableViewCell {
    var item: V!
}

protocol Reusable {}
extension UITableViewCell: Reusable {}

extension Reusable where Self: UITableViewCell  {
    static var reuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableView {
  
    func register<T: UITableViewCell>(_ :T.Type) {
        register(T.self, forCellReuseIdentifier: T.reuseIdentifier)
    }
 
    func dequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: T.reuseIdentifier, for: indexPath) as? T else {
            fatalError("Could not deque cell with identifier")
        }
        return cell
    }
}
