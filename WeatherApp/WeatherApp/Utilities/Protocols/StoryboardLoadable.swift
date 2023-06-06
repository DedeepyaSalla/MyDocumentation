//
//  StoryboardLoadable.swift
//  WeatherApp
//
//  Created by dedeepya reddy salla on 04/06/23.
//

import UIKit

protocol StoryboardLoadable {
}

extension StoryboardLoadable where Self: UIViewController {
    
    /*
     1.don't declare it in protocol definition
        - if you want to add function with default param values, because default param values are not accepted in protocol
     */
    func getVC(from storyboardName: String = DataStorageConstants.FileName.main, storyboardId: String, bundle: Bundle? = nil) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboardName, bundle: bundle)
        return storyboard.instantiateViewController(withIdentifier: storyboardId)
    }
}

protocol Searchable {
    func createSearchVC<T: UIViewController, searchDelegate: UISearchResultsUpdating> (searchVC: T, delegate: searchDelegate)
}

extension Searchable where Self: UIViewController {
    func createSearchVC<T: UIViewController, searchDelegate: UISearchResultsUpdating> (searchVC: T, delegate: searchDelegate) {
        let searchController = UISearchController(searchResultsController: searchVC)
        searchController.searchResultsUpdater = delegate
    }
}

