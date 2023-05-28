import UIKit
/*
 bundle, generic with result, observable, publisher n subscribe
 hashable, comparble, identifle, hashable, result protocol with all throw n flatmaps
 tempalte for basic tableview n cell
 template for reusables
 swift ui -- apps basics atleast three
 then understand swift ui all properties n practise each of them deeply
 */
//MARK:- Understanding syntaxes in Swift, Generics
func printAllStrs(str1: String, str2: String) -> String {
    print(str1, str2)
    return str1 + " " + str2
}

//--1
class person<T> {
    let name: T
    init(name:T) {
        self.name = name
    }
    func getNames() {}
}
/*
 Note: If you want to use generic thorught class, struct then declare it in class itself as above
 */
//2 - if generic types exists in function, then function must be informed
func printAllArgs<T>(arg1: T, arg2: T) {
    print("arg1: \(arg1), arg2: \(arg2)")
}

func getAllArgs_2a<T, Q>(arg1: T, arg2: T) -> Q {
    return person(name: "") as! Q //here swift you are telling person obj is of type is Q, so return type is accepted. But it is not guaranteed that this does not cause any crash in runtime.
}

func getAllArgs_2<T, Q>(arg1: T, arg2: Q) -> Q {
    return arg2 //here swift compiler understands that arg2 is Q based on func syntax, so return type of arg2 is accepted
}

func getAllArgs_3<T, Q>(arg1: T, arg2: T) -> Q {
    return 90 as! Q //here compiler cannot understand that 90 is of type Q, so you have to explicity say to compiler or else it gives compiler error
}

printAllStrs(str1: "string A", str2: "string B")
let dataType1 = printAllArgs(arg1: 3, arg2: 5) //sending integers
print(getAllArgs_2(arg1: 89, arg2: 890)) //o/p: 890
print(getAllArgs_2(arg1: 89, arg2: 890)) //o/p: 890
//print(getAllArgs_2a(arg1: 89, arg2: 890).Type) //err: Generic parameter 'Q' could not be inferred
//let dataType3 = printAllArgs_3(arg1: 89, arg2: 890) //err: Generic parameter 'Q' could not be inferred

//3 --
//--generic syntax for struct
/*
 if you see generic declaration started with 'Email_generic' struct. As you are using generic in one of property from struct, you need to add it parent signature. Then as you are using that struct in other struct, you need to add that generic in that other struct (Account) parent signature declaration. then only compiler will understand <T> is generic or else if simply declare Email_generic<T>, compiler will throw error as it is not any predefined dataype
 
 err:Cannot find type 'T' in scope
 */
struct Account1<T> {
    let firstName: String
    let lastName: String
    var email: String?
    var email2: Email_generic<T>?
}

struct Email_generic<GenericTypeVal>  {
    var value: GenericTypeVal?
}

var account = Account1(firstName: "", lastName: "", email2: Email_generic(value: ""))
print(account)
//generic syntax for enum
enum Result<strVal> {
    case empty
    case nonEmpty(strVal)
}

//-- func getResultEnum1(str: String) -> Result<strVal> { //err: Cannot find type 'strVal' in scope
func getResultEnum(str: String) -> Result<String> {
    
    if str.isEmpty {
        return .nonEmpty(str)
    }
    
    return .empty
}

enum Result1<success, error: Error> {
    case empty(error)
    case nonEmpty(success)
}

//--Note: here T is generic, just like success in Result1 enum. You don't need to exactly pass success here eg: func test(a: string, b: String), test(aVal, bValue) - if you see here a, arguments in func declaration and aval, bVal are not same names. That is exactly the point, you don't same names.
func getResultEnum1<T>(str: String, _: Result1<T, Error>) {
    
}

//or -- just if its generic in declaration, then anywhere we use it as argument like in this function - we must maintain generic. But those generic names need not be same
func getResultEnum2<T, Q: Error>(str: String, _: Result1<T, Q>) {
    
}

print(getResultEnum(str: "strValue"))
print(getResultEnum(str: ""))

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
