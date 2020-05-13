
import Foundation

public extension Array{
  var typeAny: Any.Type {
    let array = self
    var flag: Bool = false
    
    let expectedType = realType(array[0])
    for value in array{
      let actualType = realType(value)
      flag = (actualType == expectedType)
    }
    guard flag == false else{
      return expectedType
    }
    return Any.self
  }
}

public extension Array where  Element: Hashable, Element: Comparable {
  func unique() -> Bool {
    guard self.containsSame(as: Array(Set(self))) else{
      return false
    }
    return true
  }
}

public extension Array where Element: Comparable {
  func containsSame(as other: [Element]) -> Bool {
    return self.count == other.count && self.sorted() == other.sorted()
  }
}
