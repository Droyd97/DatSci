
import Foundation

func areEqual(_ left: Any, _ right: Any) -> Bool {
  if type(of: left) == type(of: right) &&
    String(describing: left) == String(describing: right) {
    return true
  }
  if let left = left as? [Any], let right = right as? [Any] {
    return left == right
  }
  if let left = left as? [AnyHashable],
    let right = right as? [AnyHashable] {
    return left == right
  }
  return false
}

func realType(_ value: Any) -> Any.Type{
  var actualType: Any.Type
  switch value{
  case let someInt as Int:
    actualType = type(of:someInt)
  case let someDouble as Double:
    actualType = type(of:someDouble)
  case let someString as String:
    actualType = type(of:someString)
  default:
    actualType = Any.self
  }
  return actualType
}

