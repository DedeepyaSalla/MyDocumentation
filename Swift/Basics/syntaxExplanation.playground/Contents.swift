import UIKit
/*
1.Generics - how to write syntax for generic
 for classes, functions, properties
 enums?
 2.Enums
 */

//start--------------********** 1.Generics ********** --------------

//--class with Generic type
/*
 1.If you see in below class, there is generic so you need to add its type in brackets or else compiler says what is 'T' I cannot recognize it as its not found in my pre-defined types
 2.Just compare regular syntax when you declare property or function with generic
 eg:  var nonGeneric: Bool? -> name: DAtaType
 var subscriber: T? --> same for generic property, name: GenericDataType
 same applies for function
 
 3.Declaration contains dataType, but while using we need to send value
 Decalration: func receiveNonGeneric(subscriber: String) -> declared with functionName(parameterName: dataType)
 Calling: publisher.receiveNonGeneric(subscriber: "") -> functionName.(parameter: realvalue)
 same for generic: publisher.receive(subscriber: 90) -> how does compiler know you need to pass only Ints in this generic function -> because while initializing its class object you have metnioned its type as Int
 
 4.How to intialize generic calss
 class PublisherSample<T> --> contains code related to this explanation
 
 nonGeneric class: let publisher1 = PublisherSample1()
 here compiler has clear picture of what input values it has and what all datatypes it suports -> it has two strings and one function with string param
 
 generic class: let publisher = PublisherSample() --> gives error: Generic parameter 'T' could not be inferred.
 Because calss has generic type and compiler does not know what is that generic type
 While declaratio its okay, you can give any name for generic dataType.
 But while instantiating class, its just like calling a function (because instanting a class means calling its init constructor function
 so pass expected dataType in brackets like
 
 5.But if you don't want to use generic for entire class and just use it in a function declaration, then in that case you don't to delcare <> beside class or tell its type while instanting class
 eg: func receive(subscriber: T) -> it has generic, but it gives error: cannot find 'T'
 because neither in class declaration, you have mentioend it as generic nor for function you have mentioned it as generic. So to fix this add
 func receive<T>(subscriber: T)
 */

//1--class without Generic
class PublisherSample1 {
    var subscriber: String?
    var nonoptionalSubscriber = ""
    
    func receive(subscriber: String) {
        self.subscriber = subscriber
    }
}

let publisher1 = PublisherSample1()
publisher1.receive(subscriber: "")

//--entire class with generic
class PublisherSample<T> {
    var nonGeneric: Bool?
    var subscriber: T?
    func receive(subscriber: T) {
        self.subscriber = subscriber
    }
    func receiveNonGeneric(subscriber: String) {
        print(subscriber)
    }
}

let publisher = PublisherSample<Int>()
publisher.receive(subscriber: 90)
publisher.receiveNonGeneric(subscriber: "")

//only one or more functions with generics, so brackets are used only in functions and not for entire class. But if you use generic for property then <> must be declared in class defintion as above, its mandatory
class PublisherSample2 {
    //var subscriber: A?
   
    func receive<T>(subscriber: T) {
        print(subscriber)
    }
    
    func printAllArgs<T>(arg1: T, arg2: T) {
        print("arg1: \(arg1), arg2: \(arg2)")
    }
    
    func getAllArgs_2a<T, Q>(arg1: T, arg2: Q) -> Q {
        return "strTest" as! Q //
        /*
         here compiler cannot understand that "strTest" is of type Q, so you have to explicity say to compiler or else it gives compiler error then only return type is accepted. But it is not guaranteed that this does not cause any crash in runtime.
         */
    }
    
    func getAllArgs_2<T, Q>(arg1: T, arg2: Q) -> Q {
        return arg2 //here swift compiler understands that arg2 is Q based on func syntax, so return type of arg2 is accepted
    }
}

let publisherSample2 = PublisherSample2()
publisherSample2.receive(subscriber: 90)

//--generic in other class or struct
/*
 if you see generic declaration started with 'Email_generic' struct. As you are using generic in one of property from struct, you need to add it parent signature. Then as you are using that struct in other struct, you need to add that generic in that other struct (Account) parent signature declaration. then only compiler will understand <T> is generic or else if simply declare Email_generic<T>, compiler will throw error as it is not any predefined dataype
 
 err:Cannot find type 'T' in scope
 */

struct Email_generic<GenericTypeVal>  {
    var value: GenericTypeVal?
}

struct Account1<T> {
    let firstName: String
    let lastName: String
    var email: String?
    var email2: Email_generic<T>?
}

var account = Account1(firstName: "", lastName: "", email2: Email_generic(value: ""))
print(account)

//---generic syntax for enum

enum Result2<success, error: Error> {
    case empty(error)
    case nonEmpty(success)
}

enum errorTypes: Error {
    case apiErrir
    case uiError
}

func getResultEnum1<T>(str: String, _: Result2<T, Error>) {
    
}

//or -- just if its generic in declaration, then anywhere we use it as argument like in this function - we must maintain generic. But those generic names need not be same
func getResultEnum2<T, Q: Error>(str: String, _: Result2<T, Q>) {
    
}

print(getResultEnum1(str: "strValue", .nonEmpty(900)))

enum Result1<strVal> {
    case empty(strVal)
    case nonEmpty(strVal)
}

//--Note: here T is generic, just like strVal in Result1 enum. You don't need to exactly pass 'strVal' name as in its declaration here eg: declaration -- func calling -- test(a: string, b: String), test(aVal, bValue) - if you see here a, arguments in func declaration and aval, bVal are not same names. That is exactly the point, you don't need same names.
func getResultEnum3<T>(str: String, result: Result1<T>) {
    print(result)
    /*
     as said in code principles, if its enum always use switch which enum case is passed.
     If enum case has associated values, then use let or var to get the value
     */
    //
    switch result {
    case .empty:
        print("no need to use let and get the empty value, because we know its empty")
    case .nonEmpty(let strResult):
        print(strResult)
    }
}

//getResultEnum1<String>(str: "empty with no associated values for enums", result: .empty)
//getResultEnum1<Int>(str: "nonEmpty with associated values for enums", result: .empty)
//getResultEnum1<Int>(str: "nonEmpty with associated values for enums", result: .empty)
getResultEnum3(str: "nonEmpty with associated values for enums", result: .nonEmpty("passed val"))
getResultEnum3(str: "nonEmpty with associated values for enums", result: .empty(""))

print("end of generics syntax explantion----")
//end--------------********** 1.Generics ********** --------------
