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
struct Account_1<T> {
    let firstName: String
    let lastName: String
    var email: String?
    var Email_1: Email_1?
    var email2: Email_generic<T>?
    
    func max() -> Int {
        let numbers = [5, 8, 2, 9, 1, 3]
        guard let maximum = numbers.max() else { return 0 }
        return maximum
    }
}

struct Email_generic <Value> {
    var value: Value?
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

struct Email_2 <Value: StringProtocol> {

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

struct Email_3 <Value: StringProtocol> {
    private var _value: Value?
    
    init(val: Value?) {
       _value = val
    }
    var value: Value? {
        get {
            return validate(email: _value) ? _value : nil
        }
        set {
            _value = newValue
        }
    }
    
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

struct Account<T> {
    let firstName: String
    let lastName: String
    var email: String?
    var Email_1: Email_1?
    var email2: Email_2<String>?
    var email3: Email_3<String>?
    //var email2: Email_2<Int>? err:Type 'Int' does not conform to protocol 'StringProtocol'
    
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
var account = Account<Any>(firstName: "first", lastName: "last", email2: Email_2())
account.email = "new@mail.com"
print(account.isValidEmail())

//-- level 1 - complicated code
/*
 the syntax for initializing, reading, and writing such properties becomes more complex
 */
account.Email_1 = Email_1()
account.Email_1?.value = ""
print(account.Email_1?.value)

//level 2 -- using stringProtocol -
/*
 here code is still complicated, only improvment we have made is the email2, value property cannot be anything except string
 */
account.email2?.value = ""
print(account.email2?.value)

//level 3 -- using stringProtocol + init to set initial value
/*
 no improvement - same syntax is used eventhough initializer exists for this struct email3 property wrapper
 */
var account2 = Account<String>(firstName: "", lastName: "", email3: Email_3(val: ""))

//-- swift property wrappers - all this complex code can be avoided and you can use the above structs as normal property

@propertyWrapper
struct EmailPropertyWrapper<val: StringProtocol> {
    var value: val?
    
    /*
     var wrappedValueTest --> if you give different name other than 'wrappedValue' like 'wrappedValueTest' compiler gives you below error
     err: Property wrapper type 'EmailPropertyWrapper' does not contain a non-static property named 'wrappedValue'
     */
    var wrappedValue: val? {
          get {
              return validate(email: value) ? value : nil
          }
          set {
              value = newValue
          }
      }
      
    private func validate(email: val?) -> Bool {
            guard let email = email else { return false }
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: email)
        }
}

@propertyWrapper
struct EmailPropertyWrapper1<Value: StringProtocol> {
    var value: Value?
    
    init(wrappedValue value: Value?) {
        self.value = value
    }
    
    var wrappedValue: Value? {
        get {
            return validate(email: value) ? value : nil
        }
        set {
            value = newValue
        }
    }
      
    private func validate(email: Value?) -> Bool {
            guard let email = email else { return false }
            let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
            let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
            return emailPred.evaluate(with: email)
        }
}

struct Account_4 {
    var firstName: String
    @EmailPropertyWrapper
    var email: String?
    /*if you don't set init in property value, it won't allow you to initialize value during declaration
     eg: var email: String? = ""
     err:Argument passed to call that takes no arguments
     
     -- you can only set and get later, but not during initialization as you have not declared any initializer
     */
    @EmailPropertyWrapper1
    var email1: String? = "test@mail.com"
}

print("---- Swift PropertyWrapper ---- ")
var account4 = Account_4(firstName: "")
account4.email = "invalidEmail" //setting value
print(account4.email) //getting value - o/p: nil
print(account4.email1)  //o/p: Optional("test@mail.com")

/*
 adding limitations to property wrapper -> eg: score variable should contain values only from 0 to 100 and if less than 0, then it should be 0 and if greater than 100 it should be 100
 Note: all property wrappers need not be Strings, so you don't need to confirm everything to stringprotocol everytime
 */
let numbers = [5, 8, 2, 9, 1, 3]
let maximum = numbers.max()
print(numbers)

@propertyWrapper
struct score {
    private let min = 0
    private let max = 0
    private var value: Int
    init(val: Int) {
        self.value = val
    }
    var wrappedValue: Int {
        get {
            //-- if val = 110((ie., >100), then result is 100. If val is 90 or 0, returns 90 or 0 as it is <100
            //return max(100, max(0,value))
             if value<0 {
                return 0
            } else if value>100 {
                return 100
            }
            return value
        }
        set {
            value = newValue
        }
    }
}

struct Game {
    @score
    var score: Int
}

var game = Game(score: score(val: 0))
game.score = 200
print(game.score)

@propertyWrapper
struct UserDefault {
    private let min = 0
    private let max = 0
    private var value: Int
    init(val: Int) {
        self.value = val
    }
    var wrappedValue: Int {
        get {
             if value<0 {
                return 0
            } else if value>100 {
                return 100
            }
            return value
        }
        set {
            value = newValue
        }
    }
}

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
