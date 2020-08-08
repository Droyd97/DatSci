/**
Copyright Alexander Oldroyd 2020

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

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

/// Converts the input of Any to the specified data type.
/// - Parameters:
///   - value: A value of type Any
///   - type: The specified value type that the value is to be converted to.
/// - Returns: Returns the value as the specified type.
func typeConverter<T>(_ value: Any, convertTo type: Any.Type) -> T? {
  var newValue: T?
  
  switch type {
  case is Int.Type:
    switch value {
    case let someDouble as Double:
      newValue = Int(someDouble) as? T
    case let someInt as Int:
      newValue = someInt as? T
    case let someString as String:
      newValue = Int(someString) as? T
    default:
      newValue = Optional.none
    }
  case is Double.Type:
    switch value {
    case let someDouble as Double:
      newValue = someDouble as? T
    case let someInt as Int:
      newValue = Double(someInt) as? T
    case let someString as String:
      newValue = Double(someString) as? T
    default:
      newValue = Optional.none
    }
  case is String.Type:
    switch value {
    case let someDouble as Double:
      newValue = String(someDouble) as? T
    case let someInt as Int:
      newValue = String(someInt) as? T
    case let someString as String:
      newValue = someString as? T
    default:
      newValue = Optional.none
    }
  case is Bool.Type:
    //TODO: Add Bool Conversion
    newValue = value as? T
  //TODO: Add Date type to conversion
  default:
    newValue = Optional.none
  }

  return newValue
}

//func typeConverter<T>(_ value: Any) -> T {
//
//  var newValue: T
//
//  switch T.self {
//  case is Int.Type:
//    newValue = value as! T
//  case is Double.Type:
//    switch value {
//    case let someDouble as Double:
//      newValue = someDouble as! T
//    case let someInt as Int:
//      newValue = Double(someInt) as! T
//    case let someString as String:
//      newValue = Double(someString) as! T
//    default:
//      print("Cannot convert Double")
//      newValue = 0 as! T
//    }
//  case is String.Type:
//    newValue = value as! T
//  case is Bool.Type:
//    newValue = value as! T
//  default:
//    print("cannot convert")
//    newValue = 0 as! T
//  }
//
//  return newValue
//}

