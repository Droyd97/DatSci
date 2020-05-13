

import Foundation

extension Dictionary where Value: Any {
  static func != (left: [Key : Value], right: [Key : Value]) -> Bool {
    return !(left == right)
  }
  static func == (left: [Key : Value], right: [Key : Value]) -> Bool {
    guard left.count == right.count else{
      return false
    }
    for element in left {
      guard let rValue = right[element.key],
        areEqual(rValue, element.value) else{
          return false
      }
    }
    return true
  }
}
