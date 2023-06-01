
 //let blogPostPublisher = NotificationCenter.Publisher(center: .default, name: .newBlogPost, object: nil)

import UIKit
import Combine

/*
 Breaking down understanding of publishers
 */

/*
 Publisher protocol
 */
/*
protocol Publisher {
    associatedtype Output
    associatedtype Failure: Error
    
    func subscribe<S: Subscirber>(_ subscriber: S) where S.Input == Output, S.Failure == Failure
}

/
 so what did we understand here -
 1.Publisher is a protocol
2.It contains Output, Failure generics. Where Output can be be any type, but Failure should be of Error type
 3.It contains one function 'subscribe' and accepts 1 input argument -> that argument must confirm to 'Subscriber' object (as of now we don't know if subscriber is protocol or class or struct or enum)
 but that subscriber's input property type should be equal to Output generic type here, and same for failure
 
 But Apple says, instead of implementing this Publisher protocol create ur own publisher by following three ways. Then you might think why have a protocl called 'publisher' in the first place, when you don't want us to implement this protocol. Well, lets find out by exploring more
 
 Method 1: Using CurrentValue Subject.
 so what is subject - it is a protocol with three methods and it confirms to Publisher. So it means if we use this protocol, it means we are implementing Publisher protocol
 
 CurrentValueSubject - It is a class which has generics Output, Failure and it implements all four methods declared by Subject protocol
 So yes, we can use this buil-in class provided by swift to create a publisher object.
 
 so what happens after we create this CurrentValueSubject(). Let's see
 */
/*
protocol Subject<Output, Failure> : AnyObject, Publisher {

    func send()
    func send(_ value: Self.Output)
    func send(subscription: Subscription)
    func send(completion: Subscribers.Completion<Self.Failure>)
}

final class CurrentValueSubject<Output, Failure> where Failure : Error {

    init(_ value: Output) {

    }

   // final var value: Output { get set }

    func send() {

    }
    final func send(_ input: Output) {
        //Sends a value to the subscriber.
        eg: whever value did set is called, publisher calls - subscriberObj.receive(value)
 or else whenever pubisher calls send again
 subscriberObj.receive( value)
 
 how the subscriber receives the value totall depend on the kind of subscription
 if subscription is to sink - or to assign
    }
    final func send(subscription: Subscription) {

    }
    final func send(completion: Subscribers.Completion<Failure>) {

    }
}
 */

// Publisher
let publisher = CurrentValueSubject<String, Never>("")

// Subscription
let subscription1: AnyCancellable = publisher.sink { value in
    print(value)
}

publisher.send("hi") // hi --
publisher.send("hello world") // hello world

subscription1.cancel()

publisher.send("Change Value!!") // Doesn't work
// Subscription
let subscription2 = publisher.sink { value in
    print(value)
}

let myRange = (0...3)
let cancellable = myRange.publisher
    .sink(receiveCompletion: { print ("completion: \($0)") },
          receiveValue: { print ("value: \($0)") })

print(cancellable)
let onlyReceive = myRange.publisher.sink { num in
    print(num)
}

print(onlyReceive)


/*

 
 */
//--basic level 1
/*
 difference between notification observer and publisher is --
 for observer - we pass notification name, whoever wants to receive that notification they should add it as observer and pass function to execute
 for publisher - we pass notification name and what function to execute there it self, whoever wants to re
 */
let tappedNotification = Notification.Name("tapped")
extension Notification.Name {
    static let newBlogPost = Notification.Name("new_blog_post")
}

struct BlogPost {
    let title: String
    let url: URL
}


class VC1 {
    let observerLabel = UILabel()
    let subscriberLabel = UILabel()
    
    init() {
        addSubscriber()
        print(self)
    }
    
    @objc func cardTapped(_ notification:Notification) {
        let title = (notification.object as? BlogPost)?.title ?? ""
        observerLabel.text = title
        print("received notification for observer: \(observerLabel.text!)")
    }
    
    func getUpdatedTitles() {
        print("observerLabel: \(observerLabel.text!)")
        print("subscriberLabel: \(subscriberLabel.text!)")
    }
    
    func addSubscriber() {
        print("added observer")
        //--added observer n  function to execute when notification is posted
        /*
         steps
         1.notification name for identification
         2.target - which is self here
         3.Function to handle notification, when notificaiotn with the registered name is received
         */
        NotificationCenter.default.addObserver(self, selector: #selector(cardTapped), name: tappedNotification, object: nil)
        
        //--adding publisher n subscriber (instead of adding observer, we add publisher n subscriber to accomplish same above task
        /*
         steps
         must import combine 1st
         1.create publisher with notification name for identification and closure to execute there itself
         2.target - is subscriber here and its created separately. The above closure will be executed on this subscriber tager
         3.once publisher n subscriber are created. We add subscriber (similar to addObserver) -> that is where link between publisher n subscriber is established
         */
        
        //--1
        let blogPostPublisher = NotificationCenter.Publisher(center: .default, name: .newBlogPost, object: nil)
            .map { (notification) -> String? in
                print("sending notification for subscriber from publlisher: ")
                return (notification.object as? BlogPost)?.title ?? ""
            }
        //--2
        let lastPostLabelSubscriber = Subscribers.Assign(object: subscriberLabel, keyPath: \.text)
        print("subscriberLabel", subscriberLabel.text)
        //--3
        print("created publisher and added subscriber to publisher")
        blogPostPublisher.subscribe(lastPostLabelSubscriber)
    }
}

//--1
let blogPostPublisher2AB = NotificationCenter.Publisher(center: .default, name: .newBlogPost, object: nil)
    .map { (notification) -> String? in
        print("sending notification for subscriber from publlisher: ")
        return (notification.object as? BlogPost)?.title ?? ""
    }

class VC2A {
    let observerLabel = UILabel()
    let subscriberLabel = UILabel()
    
    init() {
        addSubscriber()
        print(self)
    }
    
    @objc func cardTapped(_ notification:Notification) {
        let title = (notification.object as? BlogPost)?.title ?? ""
        observerLabel.text = title
        print("received notification for observer: \(observerLabel.text!)")
    }
    
    func getUpdatedTitles() {
        print("observerLabel: \(observerLabel.text!)")
        print("subscriberLabel: \(subscriberLabel.text!)")
    }
    
    func addSubscriber() {
        print("added observer")

        NotificationCenter.default.addObserver(self, selector: #selector(cardTapped), name: tappedNotification, object: nil)
        //--2
        let lastPostLabelSubscriber = Subscribers.Assign(object: subscriberLabel, keyPath: \.text)
        print("subscriberLabel", subscriberLabel.text)
        //--3
        print("created publisher and added subscriber to publisher")
        blogPostPublisher2AB.subscribe(lastPostLabelSubscriber)
    }
}

class VC2B {
    let observerLabel = UILabel()
    let subscriberLabel = UILabel()
    
    init() {
        addSubscriber()
        print(self)
    }
    
    @objc func cardTapped(_ notification:Notification) {
        let title = (notification.object as? BlogPost)?.title ?? ""
        observerLabel.text = title
        print("received notification for observer: \(observerLabel.text!)")
    }
    
    func getUpdatedTitles() {
        print("observerLabel: \(observerLabel.text!)")
        print("subscriberLabel: \(subscriberLabel.text!)")
    }
    
    func addSubscriber() {
        print("added observer")

        NotificationCenter.default.addObserver(self, selector: #selector(cardTapped), name: tappedNotification, object: nil)
        //--2
        let lastPostLabelSubscriber = Subscribers.Assign(object: subscriberLabel, keyPath: \.text)
        print("subscriberLabel", subscriberLabel.text)
        //--3
        print("created publisher and added subscriber to publisher")
        blogPostPublisher2AB.subscribe(lastPostLabelSubscriber)
    }
}


class VC2 {
    let blogPost = BlogPost(title: "getting started with the Combine framework in Swift", url: URL(string: "https://www.avanderlee.com/swift/combine/")!)
    //BlogPost(title: "Getting started with the Combine framework in Swift", url: URL(string: "https://www.avanderlee.com/swift/combine/")!)
    
    func postObserver_notifica() {
        //--notification name -> tappedNotification, .post method to send notification
        NotificationCenter.default.post(name: tappedNotification, object: blogPost)
        print("postObserver_notifica: ")
     }
    
    func postPublisher_notifica() {
        //--notification name -> newBlogPost, .Publisher method to send notification, .map operator includes closure to execute code after notification is received (in above method, we don't have that method and it needs to be declared in target class only

        NotificationCenter.default.post(name: .newBlogPost, object: blogPost)
        
        //--same
        print("postPublisher_notifica:")
    }
}

//--checking for single place --
//let vc1 = VC1()

//--checking for multiple places --
/*
 add all observers or (publisher n subscriber)
 then post notification from common place
 */
let vc2a = VC2A()
let vc2b = VC2B()

let vc2 = VC2()
vc2.postObserver_notifica()
vc2.postPublisher_notifica()
//vc1.getUpdatedTitles()
vc2a.getUpdatedTitles()
vc2b.getUpdatedTitles()

