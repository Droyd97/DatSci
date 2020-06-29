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

/// Struct used to store the paramaters of the DataFrame columns.
internal struct Column: Equatable, Hashable{
  //TODO: Set whether a column is a primary/index column
  // Title of the dataframe
  var title: String
  // Data type of the column
  var dataType: Any.Type

  // Hash the 'Column' struct so that it is equatable
  func hash(into hasher: inout Hasher) {
    hasher.combine(title)
  }
  
  static func == (lhs: Column, rhs: Column) -> Bool {
    guard lhs.title == rhs.title,
      lhs.dataType == rhs.dataType else {
        return false
    }
    return true
  }

}
