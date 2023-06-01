
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

