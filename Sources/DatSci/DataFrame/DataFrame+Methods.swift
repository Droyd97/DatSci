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

public extension DataFrame{
  
  /// Insert a row into the DataFrame
  /// - Parameters:
  ///   - values: Array of the data to be inserted
  ///   - row: Specify a row number for the values to be inserted into (Optional)
  mutating func insert( _ values: [Any],
                        row: Int? = nil,
                        errorHandler:  (DataFrameError) -> Void = { _ in } ) {
    do {
      try dataTypeChecker(columns, array: values)
    } catch DataFrameError.incorrectDataType {
      errorHandler(DataFrameError.incorrectDataType)
    } catch {
      fatalError("Error")
    }
    
    guard values.count == columns.count - 1 else{
      errorHandler(DataFrameError.rowsNotEqual)
      return
    }

    var rowIndex = data[columns[0].title]!.count
    if let rowed: Int = row {
      rowIndex = rowed
    }
    var value = values
    value.insert( rowIndex, at: 0)
    var i = 0
    for header in columns {
      data[header.title]!.insert(value[i], at: rowIndex)
      i += 1
    }
    totalRows += 1
    data[columns[0].title] = Array(0...totalRows - 1)
  } 
  
  /// Insert a column into the DataFrame
  /// - Parameters:
  ///   - title: The column title
  ///   - value: The data for the column that is being inserted.
  ///   - position: The position that the column should be inserted into (Optional). If left empty the column will be added to the end.
  mutating func addColumn(title: String, value: [Any],
                          position: Int? = nil,
                          errorHandler: (DataFrameError) -> Void = { _ in } ) {
    guard arrayDataTypeIsEqual(value) == true else{
      errorHandler(DataFrameError.incorrectDataType)
      return
    }
    guard value.count == totalRows else {
      errorHandler(DataFrameError.rowsNotEqual)
      return
    }
    guard columns.isUnique == true else{
      errorHandler(DataFrameError.columnsNotUnique)
      return
    }
    
    if let pos: Int = position{
      columns.insert(Column(title: title, dataType: value.typeAny), at: pos + 1)
    } else {
      columns.append(Column(title: title, dataType: value.typeAny))
    }
    
    data[title] = value
  }
  
  /// Delete a row in a DataFrame
  /// - Parameter row: Specify the row to delete (Optional). If no value is specified the last row will be removed.
  mutating func delete(row: Int? = nil){
    var row = row
    if row == nil {
      row = totalRows - 1
    }
    for header in columns {
      data[header.title]!.remove(at: row!)
    }
    totalRows -= 1
    data[columns[0].title] = Array(0...totalRows - 1)
  }
  
  // TODO: Add ability for non integer index
  /// Add a numbered index to the DataFrame
  mutating func addIndex() {
    columns.insert(Column(title: "index", dataType: Int.self), at: 0)
    guard totalRows != 0 else{
      return
    }
    data["index"] =  Array(0...totalRows - 1)
    
  }
  
  enum sortOrder {
    case ascending
    case descending
  }
  
  mutating func sortValues(by: String, sort: sortOrder = .ascending) {
    let offset: [Int]
    if let array = data[by] {
      switch(sort) {
      case .ascending:
        switch(array[0]) {
        case _ as Int:
          let arrayInt = array.map({Int($0 as! Int)})
          offset = arrayInt.enumerated().sorted(by: {$0.element < $1.element}).map({$0.offset})
        case _ as Double:
          let arrayDouble = array.map({Double($0 as! Double)})
          offset = arrayDouble.enumerated().sorted(by: {$0.element < $1.element}).map({$0.offset})
        case _ as String:
          let arrayString = array.map({String($0 as! String)})
          offset = arrayString.enumerated().sorted(by: {$0.element < $1.element}).map({$0.offset})
        default:
          fatalError("Failed to sort")
        }
      case .descending:
        switch(array[0]) {
        case _ as Int:
          let arrayInt = array.map({Int($0 as! Int)})
          offset = arrayInt.enumerated().sorted(by: {$0.element > $1.element}).map({$0.offset})
        case _ as Double:
          let arrayDouble = array.map({Double($0 as! Double)})
          offset = arrayDouble.enumerated().sorted(by: {$0.element > $1.element}).map({$0.offset})
        case _ as String:
          let arrayString = array.map({String($0 as! String)})
          offset = arrayString.enumerated().sorted(by: {$0.element > $1.element}).map({$0.offset})
        default:
          fatalError("Failed to sort")
        }
      }
      for (key,column) in data {
        data[key] = offset.map({ column[$0] })
      }
    }
  }
  
  
  mutating func asType(column: String, type: Any.Type) {
    let currentType = columns[columns.firstIndex(where: ({$0.title == column}))!].dataType
    switch type {
    case is Int.Type:
      let _: [Int] = data[column]!.map({(typeConverter($0, convertTo: Int.self)!)})
      columns[columns.firstIndex(where: ({$0.title == column}))!].dataType = Int.self
    case is Double.Type:
      let _: [Double] = data[column]!.map({typeConverter($0, convertTo: Double.self)!})
      columns[columns.firstIndex(where: ({$0.title == column}))!].dataType = Double.self
    case is String.Type:
      let _: [String] = data[column]!.map({typeConverter($0, convertTo: String.self)!})
      columns[columns.firstIndex(where: ({$0.title == column}))!].dataType = String.self
    default:
      fatalError("Cannot Convert")
    }
  }

//  func isUnique() -> [String]{
//    var uniqueArray: [String]
//    for header in columns{
//      let dataFrameData = self.data[header]
//      if dataFrameData!.unique() {
//        uniqueArray.append(header)
//      }
//    }
//  }
  
  //TODO: Add max functiom
//  func max() {
//
//  }
//
  //TODO: ADD min function
//  func min() {
//
//  }
//
  //TODO: Add prefix to all columns
//  mutating func addPrefix() {
//
//  }

  

}
