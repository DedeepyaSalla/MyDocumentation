//
//  WeatherIconRequest.swift
//  WeatherApp
//
//  Created by dedeepya reddy salla on 06/06/23.
//

import UIKit

struct WeatherIconRequest: DataRequest {

    var url: String {
        if let imageIcon = imageIcon {
            return APIConstants.HttpString.iconRequestUrl + imageIcon + "@2x.png"
        } else {
            return ""
        }
    }
    
    var imageIcon: String?
    
    func decode(_ data: Data) -> UIImage? {
        guard let image = UIImage(data: data) else {
            return nil
        }
        return image
    }
}
