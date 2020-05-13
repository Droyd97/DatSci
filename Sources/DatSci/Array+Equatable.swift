
import Foundation

public extension Array where Element: Any {
  static func != (left: [Element], right: [Element]) -> Bool {
    return !(left == right)
  }
  static func == (left: [Element], right: [Element]) -> Bool {
    guard left.count == right.count else{
      return false
    }
    var right = right
    loop: for lValue in left{
      for (rIndex, rValue) in right.enumerated() where areEqual(lValue, rValue) {
        right.remove(at: rIndex)
        continue loop
      }
      return false
    }
    return true
  }
}




