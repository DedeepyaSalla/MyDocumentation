import UIKit
import Foundation
/*
 1.Concepts covered property wrapper, published
 2.Observable in swift
 */
//MARK:- why do we need property wrapper -- start from basic level

/*
 Issues: what if you want to check validity of email in below struct, we add a function for isValidEmail
 1.if we add function to class, then that validation is specific only to that class,
 2.If we add global access using singleton, its useless because we can't keep on adding all funcions in global memory when we have more better option,
 3.If we use extension like string, yes it works really well but extension makes it accessible to all strings--
   using property as a wrppaer advantages
        -  When you want this functionality to limit only to email property
        - it can be secure because we don't need to expose the email funcnality to external objects and just return email if its valid and nil if it is not the case.
        - Constraints, Database, business logic along with getters and setters: Also, what if we want to add some extra features to this email property along with email validation, then by wrapping all this in single struct we could easily achive this
        
 
 https://www.toptal.com/swift/wrappers-swift-properties#:~:text=A%20property%20wrapper%20is%20a,or%20add%20some%20additional%20methods.
 level 1: Fix - wrapping in single struct and adding getter, setter n adding any other features as extra function will work. Issues here
    - its a struct not string, so to just access email string or set email string - you need emailStructObj.value - so unnecessarily lengthy process
    - Level 2: fix for this -> confirmt the struct to StringProtocol. It means you are adding a generic which says ur property is String. so, if u declare Int as generic datatype, then it won't accept
     eg: var email2: Email_2<Int>?
     //err:Type 'Int' does not conform to protocol 'StringProtocol'
 But more optiized way is to use property wrappers
 */
//--generic syntax for struct
struct Account1<T> {
    let firstName: String
    let lastName: String
    var email: String?
    var Email_1: Email_1?
    var email2: Email_generic<T>?
}

struct Email_generic <Value> {
    var value: Value?
}

struct Account<T> {
    let firstName: String
    let lastName: String
    var email: String?
    var Email_1: Email_1?
    var email2: Email_2<T>?
    //err:Type 'Int' does not conform to protocol 'StringProtocol'
    
    func isValidEmail() -> Bool {
        guard let email = self.email else {
            return false
        }
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-za-z]{2,64}"
       let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        /*
         Returns a Boolean value that indicates whether the specified object matches the conditions that the predicate specifies.
         */
       return pred.evaluate(with: email)
    }
}

extension String {
    func isValidEmail(email: String?) -> Bool {
        guard let email = email else {
            return false
        }
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-za-z]{2,64}"
       let pred = NSPredicate(format: "SELF MATCHES %@", regex)
       return pred.evaluate(with: email)
    }
}

struct Email_1 {

    var value: String? {
        get {
            return validate(email: _value) ? _value : nil
        }
        set {
            _value = newValue
        }
    }
    
    private var _value: String?
    
    private func validate(email: String?) -> Bool {
        guard let email = email else { return false }
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-za-z]{2,64}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: email)
    }
}

struct Email_2 <Value> {

    var value: Value? {
        get {
            return validate(email: _value) ? _value : nil
        }
        set {
            _value = newValue
        }
    }
    
    private var _value: Value?
    
    private func validate(email: Value?) -> Bool {
        guard let email = email else { return false }
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-za-z]{2,64}"
        let pred = NSPredicate(format: "SELF MATCHES %@", regex)
        return pred.evaluate(with: email)
    }
}
/*
 Note: assigned var to email property and account object because you want to change email later and to change any of its child properties - struct must be var unlike class
 */
var account = Account(firstName: "first", lastName: "last", email: "firstLast@email.com")
account.email = "new@mail.com"
print(account.isValidEmail())

//-- level 1 - complicated code
account.Email_1 = Email_1()
account.Email_1?.value = ""
print(account.Email_1?.value)

//level 2 -- using stringProtocol




//MARK:- Understanding syntaxes for Observable in Swift
print("---- Observable in Swift ---- ")

class Contact: ObservableObject {
    @Published var name: String
    @Published var age: Int

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }

    func haveBirthday() -> Int {
        age += 1
        return age
    }
}

class Contact1 {
     var name: String
     var age: Int {
        willSet {
            print("willset age", age)
        }
    }

    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }

    func haveBirthday() -> Int {
        age += 1
        return age
    }
}

//--with observable
let john = Contact(name: "John Appleseed", age: 24)
john.objectWillChange
    .sink { _ in
        print("\(john.age) will change")
}

func testingObservable() {
    for _ in 1..<10 {
        print(john.haveBirthday())
    }
}
testingObservable()

//--without observable
print("---- without Observable in Swift ---- ")
let john1 = Contact1(name: "John Appleseed", age: 24)
func testingObservable1() {
    for _ in 1..<10 {
        print(john1.haveBirthday())
    }
}
testingObservable1()
