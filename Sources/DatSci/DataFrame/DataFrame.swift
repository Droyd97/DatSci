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
import Logging
//TODO: Add functionality to allow the index to be non zero
/// Two-dimensional tabular data
public struct DataFrame: ExpressibleByDictionaryLiteral, CustomStringConvertible, Equatable {
  // The title and datatype of each column is stored in a Column struct.
  var columns: [Column] = []
  // The data of the dataframe.
  var data: [String: [Any]]
  // The total number of rows of the dataframe.
  var totalRows: Int
  
  //MARK: Initializer
  /**
   Creates an instance of a DataFrame from the dictionary literal.
   
   ## Usage Example ##
   ```swift
   let dataframe: DataFrame = ["name": ["James", "Oliver", "Simon"], "age": [19,25,56]]
   ```
   - Parameter elements: Dictionary Literal
   */
  public init(dictionaryLiteral elements: (String, [Any])...){
    guard elements.count != 0 else {
      self.totalRows = 0
      self.data = [:]
      return
    }
  
    self.totalRows = elements[0].1.count

    for (element,_) in elements{
      columns.append(Column(title: element, dataType: String.self))
    }

    guard columns.isUnique == true else{
      fatalError("Columns columns are not unique")
    }

    data = elements.reduce(into:[:]){$0[$1.0] = $1.1}
    addIndex()
    DataFrame.dataTypeInitiator(data, headers: &columns)
}
  
  /// Set custom print for the DataFrame so that it displays as a table
  public var description: String {
    //TODO: Add options so only 10 rows are printed
    //TODO: Remove Force Unwrapped
    var dataFrameString: String = ""
    let columnSizes = maxColumnLengths()
    for i in columns{
      dataFrameString += i.title.padding(toLength: columnSizes[columns.firstIndex(of: i)!] + 4, withPad: " ", startingAt:0)
    }
    dataFrameString += "\n" + "".padding(toLength: columnSizes.reduce(0, +) + (columns.count * 4), withPad:"-", startingAt:0) + "\n"
    guard totalRows != 0 else{
      return dataFrameString
    }
    for i in 0...totalRows - 1 {
      for ii in columns {
        dataFrameString += "\(data[ii.title]![i])".padding(toLength:columnSizes[columns.firstIndex(of: ii)!] + 4, withPad: " ", startingAt: 0)
      }
      dataFrameString += "\n"    
    }
    return dataFrameString
  }
  
  
  public subscript<T>(col: String) -> [T] {
    get {
      var value: [T]
      if let index = columns.firstIndex(where: ({$0.title == col})) {
        value = data[columns[index].title, default: []].map({(typeConverter($0, convertTo: columns[index].dataType) ?? fatalError("Cannot convert DataType"))})
      } else {
        value = []
      }
      return value
    }
    set {
      return data[columns[columns.firstIndex(where: ({$0.title == col}))!].title] = newValue
    }
  }
  
  
  public subscript(row: Int, col: Int) -> Any {
    get {
      return data[columns[col].title]![row]
    }
    set {
      return data[columns[col].title]![row] = newValue
    }
  }
  
  //TODO: Have an ability to SLICE with index rather then create new DataFrame
  public subscript(rowRange: ClosedRange<Int>, columnRange: ClosedRange<Int>) -> DataFrame {
    get {
      var newDataFrame: DataFrame = [:]
      newDataFrame.totalRows = rowRange.count
      newDataFrame.columns.append(Column(title:"index", dataType: Int.self))
      newDataFrame.data["index"] = Array(0...newDataFrame.totalRows - 1)
      for head in columns[columnRange] {
        guard head.title != "index" else {
          continue
        }
        newDataFrame.columns.append(head)
        newDataFrame.data[head.title] = Array(data[head.title]![rowRange])
      }
      return newDataFrame
    }
  }
  
  
  /// Returns the max length of each column of the DataFrame in order for the columns to be printed at their correct width.
  /// - Returns: Returns the max character length of each column.
  func maxColumnLengths() -> [Int] {
    var max: [Int] = [Int](repeating: 0, count: columns.count)
    var i = 0
    for header in columns{
      var stringCount: Int
      if let dataFrameData = data[header.title]{
        for dat in dataFrameData{
          switch dat{
          case let someInt as Int:
            stringCount = String(someInt).count
          case let someDouble as Double:
            stringCount = String(someDouble).count
          case let someString as String:
            stringCount = String(someString).count
          default:
            fatalError()
          }
        if max[i] < stringCount {
          max[i] = stringCount
        }
          if max[i] < header.title.count {
            max[i] = header.title.count
        }
      }
      } else{
        if max[i] < header.title.count {
          max[i] = header.title.count
        }
      }
      i += 1
    }
    return max
  }

// TODO: REWRITE WITH FUNCTION ARRAYDATATYPEISEQUAL
  static func dataTypeInitiator(_ data: [String: [Any]], headers: inout [Column]) {
    for (header, array) in data{
      let checkType = type(of: array[0])
      for value in array{
        guard checkType == type(of: value) else{
          fatalError("Columns must be of same Type. Got \(type(of:value)) expected \(checkType)")
        }
        if let index = headers.firstIndex(where: ({$0.title == header})) {
          headers[index].dataType = checkType
        }
      }
    }
  }

  // TODO: Change name and use with above function
  static func dataTypeInitiator(_ data: [[Any]], headers: [String]) -> [Any.Type] {
    var dataTypes = [Any.Type](repeating: String.self, count: headers.count)
    for array in data {
      let checkType = type(of: array[0])
      for value in array {
        guard checkType == type(of: value) else{
          fatalError("Columns must be of same Type. Got \(type(of:value)) expected \(checkType)")
        }
       dataTypes.append(checkType)
      }
    }
  return dataTypes
  }
    
  // func isEqual<T: Equatable>(type: T.Type, _ a: Any, _ b: Any) -> Bool {
  //   guard let a = a as? T, let b = b as? T else { return false}
  //   return a == b
  // }

  func dataTypeChecker(_ columns: [Column], array: [Any]) throws {
    var i = 1
    for value in array{
      guard type(of: value) == columns[i].dataType else {
        throw DataFrameError.incorrectDataType
      }
      i += 1
    }
  }

  func arrayDataTypeIsEqual(_ array: [Any]) -> Bool {
    let checkType = type(of:array[0])
    var bool = true
    for value in array{
      guard checkType == type(of: value) else{
        bool = false
        return bool
      }
    }
    return bool
  }

  mutating func concat(_ datFrame: DataFrame) {
    for (header, values) in data{
      var array = values
      array += datFrame.data[header]!
      data[header] = array
    }
   totalRows += datFrame.totalRows
  }
  

}

public enum DataFrameError: Error {
  case incorrectDataType
  case rowsNotEqual
  case columnsNotUnique
}

extension DataFrameError: LocalizedError {
  public var errorDescription: String? {
    switch self {
    case .incorrectDataType:
      return NSLocalizedString("Data types do not match", comment: "")
    case .rowsNotEqual:
      return NSLocalizedString("Rows do not add up", comment: "")
    case .columnsNotUnique:
      return NSLocalizedString("Columns are not unique", comment: "")
    }
  }
}


// public func matToDf(_ matrix: Matrix, columns: [String]) -> DataFrame{
//   var newDataFrame: DataFrame = [:]
//   let columns = matrix.dimensions.columns
//   let rows = matrix.dimensions.rows
//   for column in columns{
//   }
