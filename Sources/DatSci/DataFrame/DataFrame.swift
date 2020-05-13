import Foundation

public struct DataFrame: ExpressibleByDictionaryLiteral, CustomStringConvertible, Equatable{
  
  var headers: [String] = []
  var dataTypes: [Any.Type] = []
  var data: [String: [Any]]
  var totalRows: Int

  public init(dictionaryLiteral elements: (String, [Any])...){
    guard elements.count != 0 else{
      self.totalRows = 0
      self.data = [:]
      return
    }
  
    self.totalRows = elements[0].1.count

    for element in elements{
      headers.append(element.0)
    }

    guard headers.isUnique == true else{
      fatalError("Columns headers are not unique")
    }

    data = elements.reduce(into:[:]){$0[$1.0] = $1.1}
    addIndex()
    self.dataTypes = dataTypeInitiator(data, headers: headers)    
}

  public var description: String {
    var matrixString: String = ""
    let columnSizes = maxColumnLengths()
    for i in headers{
      matrixString += i.padding(toLength: columnSizes[headers.firstIndex(of: i)!] + 4, withPad: " ", startingAt:0)
    }
    matrixString += "\n"
    matrixString += "".padding(toLength: columnSizes.reduce(0, +) + (headers.count * 4), withPad:"-", startingAt:0)
    matrixString += "\n"
    guard totalRows != 0 else{
      return matrixString
    }
    for i in 0...totalRows - 1 {
      for ii in headers{
        matrixString += "\(data[ii]![i])".padding(toLength:columnSizes[headers.firstIndex(of: ii)!] + 4, withPad:" ", startingAt:0)
      }
      matrixString += "\n"    
    }
    return matrixString
  }
  
  public static func == (lhs: DataFrame, rhs: DataFrame) -> Bool {
    guard lhs.headers == rhs.headers,
      lhs.dataTypes == rhs.dataTypes,
      lhs.data == rhs.data,
      lhs.totalRows == rhs.totalRows else{
        return false
    }
    return true
  }


  func maxColumnLengths() -> [Int]{
    var max: [Int] = [Int](repeating: 0, count: headers.count)
    var i = 0
    for header in headers{
      var stringCount: Int
      if let dataFrameData = data[header]{
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
        if max[i] < header.count {
          max[i] = header.count
        }
      }
      } else{
        if max[i] < header.count {
          max[i] = header.count
        }
      }
      i += 1
    }
    return max
  }

  // func maxCellLength() -> Int{
  //   var max = 0
  //   for (_, array) in data {
  //     for value in array{
  //       switch value{
  //         case let someInt as Int:
  //           let stringCount = String(someInt).count
  //           if max < stringCount {
  //             max = stringCount
  //           }
  //         case let someDouble as Double:
  //           let stringCount = String(someDouble).count
  //           if max < stringCount {
  //             max = stringCount
  //           }
  //         case let someString as String:
  //           let stringCount = someString.count
  //           if max < stringCount {
  //             max = stringCount
  //           }
  //         default:
  //           fatalError()
  //     }
  //   }  
  // }
  // return max
  // }

// REWRITE WITH FUNCTION ARRAYDATATYPEISEQUAL
  func dataTypeInitiator(_ data: [String: [Any]], headers: [String]) -> [Any.Type] {
    var dataTypes = [Any.Type](repeating: String.self , count: headers.count)
    for (header, array) in data{
      let checkType = type(of:array[0])
      for value in array{
        guard checkType == type(of:value) else{
          fatalError("Columns must be of same Type. Got \(type(of:value)) expected \(checkType)")
        }
        dataTypes[headers.firstIndex(of:header)!] = checkType
      }
    }
    return dataTypes
  }

  // func isEqual<T: Equatable>(type: T.Type, _ a: Any, _ b: Any) -> Bool {
  //   guard let a = a as? T, let b = b as? T else { return false}
  //   return a == b
  // }
  func dataTypeChecker(_ dataTypes: [Any.Type], array: [Any]){
    var i = 1
    for value in array{
      guard type(of:value) == dataTypes[i] else {
        fatalError("Incorrect Data Type")
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

  mutating func concat(_ datFrame: DataFrame){
    for (header, values) in data{
      var array = values
      array += datFrame.data[header]!
      data[header] = array
    }
   totalRows += datFrame.totalRows
  }
  


}



// public func matToDf(_ matrix: Matrix, columns: [String]) -> DataFrame{
//   var newDataFrame: DataFrame = [:]
//   let columns = matrix.dimensions.columns
//   let rows = matrix.dimensions.rows
//   for column in columns{

//   }



//   return newDataFrame
// }
