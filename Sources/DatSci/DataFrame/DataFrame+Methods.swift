public extension DataFrame{

  mutating func insert( _ values: [Any], row: Int? = nil){
    dataTypeChecker(dataTypes, array: values)
    guard values.count == headers.count - 1 else{
      fatalError()
    }
    var rowIndex = data[headers[0]]!.count
    if let rowed: Int = row {
      rowIndex = rowed
    }
    var value = values
    value.insert( rowIndex, at: 0)
    var i = 0
    for header in headers {
      data[header]!.insert(value[i], at: rowIndex)
      i += 1
    }
    totalRows += 1
    data[headers[0]] = Array(0...totalRows - 1)
  } 

  mutating func addColumn(column: String, value: [Any], position: Int? = nil ){
    guard arrayDataTypeIsEqual(value) == true else{
      fatalError("Data is not of same type")
    }
    guard value.count == totalRows else {
      fatalError("Number of values does not match")
    }
    
    if let pos: Int = position{
      headers.insert(column, at: pos + 1)
      dataTypes.insert(value.typeAny, at: pos + 1)
    } else {
      headers.append(column)
      dataTypes.append(value.typeAny)
    }
    

    guard headers.isUnique == true else{
      fatalError("Columns headers are not unique")
    }
    data[column] = value
  }

  mutating func delete(row: Int? = nil){
    var row = row
    if row == nil {
      row = totalRows - 1
    }
    for header in headers {
      data[header]!.remove(at: row!)
    }
    totalRows -= 1
    data[headers[0]] = Array(0...totalRows - 1)
  }
  
  mutating func addIndex(){
    headers.insert("index",at:0)
    guard totalRows != 0 else{
      return
    }
    data["index"] =  Array(0...totalRows - 1)
    dataTypes.insert(Int.self, at:0)
    
  }

//  func isUnique() -> [String]{
//    var uniqueArray: [String]
//    for header in headers{
//      let dataFrameData = self.data[header]
//      if dataFrameData!.unique() {
//        uniqueArray.append(header)
//      }
//    }
//  }
  
  func max(){

  }

  func min(){

  }

  mutating func addPrefix(){

  }

  

}
