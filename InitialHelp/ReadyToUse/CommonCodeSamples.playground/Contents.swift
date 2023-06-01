import UIKit
/*
1.Predicate,
 */

func validate(email: Value?) -> Bool {
    guard let email = email else { return false }
    let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-za-z]{2,64}"
    let pred = NSPredicate(format: "SELF MATCHES %@", regex)
    return pred.evaluate(with: email)
}
