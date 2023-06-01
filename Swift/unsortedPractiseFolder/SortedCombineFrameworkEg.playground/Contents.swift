/*
 remember while writing the new code, you don't need to write a perfect code with perfect architecture and think about fine tuning immediately.
 First, get all the requirements. Then plan to implement the functionality which covers all these requirements. Yes, if you are very much experienced with protocol oriented programming and you have develope tons of new features already you don't need to follow these steps. But if you are implementing your 1st new feature from scratch and still you are trying to understand the best ways of architecture and design patterns to follow, then please start slow
 */

/*
 what do you want to here, want to mock publisher and subscription functionality just like Apple with ur own custom classes and protocols.
 Then after that want to find why to use protocol-oriented programing architecture, instead of just using classes to implement this publisher and subscriber
 */

/*
 Basic : phase 1 -
 Here understand what publisher does, what subscriber does and what the final outcome should when using them
 consider sending to only one subscriber for now - later you can think of sending to multiple subscribers
 
 */
//--Publisher
/*
 Def: Declares that a type can transmit a sequence of values over time.
 Implementation: so use class for now, have a function to send data periodically
 But when should you send data and to whom should you send?
 
 Def: The publisher implements the receive(subscriber:)method to accept a subscriber.
 the subscriber uses the subscription to demand elements from the publisher and can use it to cancel publishing.
 
 Implementation: receive(subscriber:)method exists in pubisher, it is called  by subscriber and this method returns back the subscription object to subscriber.
 Why it returns back the subscription instance to subscriber. using that instance subscriber can request any info it needs from publisher or it can cancel the subscription also.
 
 receive(subscription:): Acknowledges the subscribe request and returns a Subscription instance. The subscriber uses the subscription to demand elements from the publisher and can use it to cancel publishing.
 receive(_:): Delivers one element from the publisher to the subscriber.
 receive(completion:): Informs the subscriber that publishing has ended, either normally or with an error.
 
To simplify we want a publisher
 which stores all subscribers info,
 returns back subscription object to each subscriber to inform subscription is activatged
 Then sends elements to subscriber when subscriber requests anything and finally sends finished if all the requested elements are sent successfully.
 
 So lets implement till here
 */

enum PublishedDataStatus {
    case finished
    case error
}
//class PublisherSample <SubscriberSample, T> {
//
//    var subscriber = ""
//    func receive(subscriber: SubscriberSample) {
//
//    }
//
//    func sendData(data: T) {
//
//    }
//    func sendData(data: T, completion: PublishedDataStatus){
//
//    }
//}

class subscriberSample {
    
    var data = ""
    init() {
        
    }

    func receivedData(input: String) {
        data = input + data
        print(data)
    }
    
    func finalStatus(status: PublishedDataStatus) {
        print(status)
    }
    
    func receivedData(input: String, completion: (PublishedDataStatus) -> Void) {
        data = input + data
        print(data)
    }
}


class PublisherSample<T> {
   
    var subscriber: subscriberSample?
    var subscriber1: T?
    
    // Subscriptoin
    var subscription =  { value in
        print("inside subscription")
        print(value)
    }
    
    var sinkSubscription: ((String) -> Void)?
    var valClosure: ((String) -> Void)?
    
    func receive(subscriber: subscriberSample) {
        self.subscriber = subscriber
    }

    func sendData(data: String) {
        subscriber?.receivedData(input: data)
    }
    
    func sendDataToSubscriber(data: String) {
        print("sending data to subscriber")
       //- can be written like to handle optional closure -> (sinkSubscription ?? {$0})(data)
        if let sinkSubscription = sinkSubscription {
            sinkSubscription(data)
        }
        //--once sending data finishes, you can then call status completion at end
    }
    
    func sink(data: String, completionCall: (String) -> Void) {
        print("came to sink")
        completionCall(data)
    }
    
    func publisherSink(completionCall : @escaping (String )-> Void) {
        print("came to publisher sink and assigned closure to send while publishing")
        sinkSubscription = completionCall
    }
    
    func publisherSink_1(completionCall : (String )-> Void) {
        print("came to publisher sink and assigned closure to send while publishing")
        //sinkSubscription = completionCall
        //err: Assigning non-escaping parameter 'completionCall' to an @escaping closure
    }
    
    func publisherSink_2(statusCompletion: @escaping (String) -> Void, valueCompletion: @escaping (String) -> Void) {
        sinkSubscription = statusCompletion
        valClosure = valueCompletion
    }
    
    func sendDataInChunks(data: [String]) {
        
        var count = 0
        data.forEach { str in
            subscriber?.receivedData(input: str)
            count = count + 1
        }
        
        if count == data.count {
            subscriber?.finalStatus(status: .finished)
        } else {
            subscriber?.finalStatus(status: .error)
        }
    }
    
    func sendData(data: [String], completion: (PublishedDataStatus) -> Void){
        print("sending data with completion")
        data.forEach { str in
            subscriber?.receivedData(input: str, completion: { status in
                print(status)
            })
        }
    }
}


let publisher = PublisherSample<Int>()
publisher.receive(subscriber: subscriberSample())

class VC {
    init() {
        //start subscription
        let publisher = PublisherSample<Int>()
        publisher.receive(subscriber: subscriberSample())
    }
    

}

