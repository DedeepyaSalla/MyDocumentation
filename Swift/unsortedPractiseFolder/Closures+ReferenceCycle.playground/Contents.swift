import UIKit

class vc1 {
    
    let viewModel = ViewModel1()
    init() {
        print("came to viewDidLoad")
    }
    
    func downloadTap(imageIndex: Int) {
        
    }
}

/*
 --usually contains all data storage related properties
 --only uielement properties and ui events are written in uiviewController
 */
class ViewModel1 {
    var imageURLs: [String] = []
    init() {
        
    }
    
    func getImage(forUrl url: URL) {
        /*
         1.performs async call here and as its asynchronours we need to write closure as the async call does not return value immediately
         2.What do we usually receive
         either response or error
         */
    }
}

class MusicService {
    
}

class CommonRestService {
    
}

let vc = vc1()
