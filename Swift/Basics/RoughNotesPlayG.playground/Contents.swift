
 //let blogPostPublisher = NotificationCenter.Publisher(center: .default, name: .newBlogPost, object: nil)

import UIKit
import Combine

/*

 
 */
//--basic level 1
/*
 difference between notification observer and publisher is --
 for observer - we pass notification name, whoever wants to receive that notification they should add it as observer and pass function to execute
 for publisher - we pass notification name and what function to execute there it self, whoever wants to re
 */
let tappedNotification = Notification.Name("tapped")

class VC1 {
    
    init() {
        NotificationCenter.default.addObserver(self, selector: #selector(cardTapped), name: tappedNotification, object: nil)
        let blogPostPublisher = NotificationCenter.Publisher(center: .default, name: .newBlogPost, object: nil)
            .map { (notification) -> String? in
                return (notification.object as? BlogPost)?.title ?? ""
            }

        print(self)
    }
    
    @objc func cardTapped(_ n:Notification) {
        print("cardTapped--")
            print(n) // or something
    }
}

class VC2 {
    func postNotificationTest() {
        print("postNotificationTest--")
         NotificationCenter.default.post(name: tappedNotification, object: self)
     }
}

let vc1 = VC1()
let vc2 = VC2()
vc2.postNotificationTest()

let myRange = (0...3)
let cancellable = myRange.publisher
    .sink(receiveCompletion: { print ("completion: \($0)") },
          receiveValue: { print ("value: \($0)") })
print(cancellable)

 extension Notification.Name {
     static let newBlogPost = Notification.Name("new_blog_post")
 }

 struct BlogPost {
     let title: String
     let url: URL
 }

 let blogPostPublisher = NotificationCenter.Publisher(center: .default, name: .newBlogPost, object: nil)
     .map { (notification) -> String? in
         return (notification.object as? BlogPost)?.title ?? ""
     }

 let lastPostLabel = UILabel()
 let lastPostLabelSubscriber = Subscribers.Assign(object: lastPostLabel, keyPath: \.text)
 blogPostPublisher.subscribe(lastPostLabelSubscriber)

 let blogPost = BlogPost(title: "Getting started with the Combine framework in Swift", url: URL(string: "https://www.avanderlee.com/swift/combine/")!)
 NotificationCenter.default.post(name: .newBlogPost, object: blogPost)
 print("Last post is: \(lastPostLabel.text!)")
 // Last post is: Getting started with the Combine framework in Swift
