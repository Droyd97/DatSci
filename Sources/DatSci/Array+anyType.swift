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
