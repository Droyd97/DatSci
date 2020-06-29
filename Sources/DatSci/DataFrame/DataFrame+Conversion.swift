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
import SwiftKuery
import SwiftKueryPostgreSQL

public extension DataFrame {
  /// Convert a JSON to a DataFrame as specified by the Codable struct.
  /// - Parameters:
  ///   - data: JSON data
  ///   - model: The model in which the JSON follows
  ///   - path: The path of the .json file
  /// - Returns: A DataFrame is produced from the JSON
  static func jsonToDataFrame<T,V>(data: Foundation.Data,
                                   model: T.Type,
                                   path: KeyPath<T,V> ) -> DataFrame  where T: Codable {
    var newDataFrame: DataFrame = [:]
    do{
      let decoder = JSONDecoder()
      let json = try decoder.decode(model, from: data)
      let jsonData = json[keyPath:path]
      let structMirror = Mirror(reflecting: jsonData)
      for struc in structMirror.children{
        let childMirror = Mirror(reflecting: struc.value)
        print(childMirror.children)
        for child in childMirror.children{
          guard newDataFrame.data[child.label!] != nil else{
            //TODO: Rewrite as its own function
            newDataFrame.data[child.label!] = [child.value]
            newDataFrame.columns.append(Column(title: child.label!, dataType: type(of:child.value)))
            continue
          }

          guard newDataFrame.columns[newDataFrame.columns.firstIndex(where: ({$0.title == child.label!}))!].dataType == type(of:child.value) else {
            fatalError("Data types do not match")
          }
          newDataFrame.data[child.label!]!.append(child.value)
          
        }
        newDataFrame.totalRows += 1
      }
    } catch{
      print("Error with Conversion")
    }
    newDataFrame.addIndex()
    return newDataFrame
  }
  
  
  /// Convert a CSV to a DataFrame
  /// - Parameters:
  ///   - path: File path of the CSV file
  ///   - headerFlag: Set as 'true' when the first row of the csv is the header titles. Default is 'true'.
  /// - Returns: <#description#>
  static func csvToDataFrame(_ path: URL,
                             isHeader headerFlag: Bool = true) -> DataFrame {
    
    var newDataFrame: DataFrame = [:]
    
    let inputStream = InputStream(url: path)!
    
    var parse = ParserToDict(inputStream, headerFlag: headerFlag)
    parse.parse()
    
    newDataFrame.columns = parse.headers!.map{Column(title: $0, dataType: String.self)}
    newDataFrame.totalRows = parse.row
    newDataFrame.data = parse.value
    
    return newDataFrame
  }
  
  /// Create a table in SQL of the specified DataFrame
  /// - Parameters:
  ///   - dataFrame: DataFrame to convert
  ///   - tableName: Name of the SQL Table
  ///   - host: SQL Host
  ///   - port: SQL Port
  ///   - options: Connection Options
  ///   - poolOptions: Connection Pool Options
  static func dataFrameToSQL(_ dataFrame: DataFrame,
                             tableName: String, host: String = "localhost",
                             port: Int32 = 5432, options: [ConnectionOptions],
                             poolOptions: ConnectionPoolOptions = ConnectionPoolOptions(initialCapacity: 1, maxCapacity: 1)) {
    
    let pool = PostgreSQLConnection.createPool(host: host, port: Int32(port), options: options, poolOptions: poolOptions)
    
    let query = QueryBuilder(dataFrame)
    SQLORM.checkTable(pool, table: "test") { exists in
      switch exists {
      case .success(let exists):
        if exists {
          return
        } else {
          query.createTable(tableName)
          SQLORM.rawQuery(pool, query: query.stringQuery)
        }
      case .failure(let error):
        print(error)
      }
    }
    query.insertData("test")
    SQLORM.rawQuery(pool, query: query.stringQuery) 
  }
  
  
  
  static func matToDF(_ matrix: Matrix) -> DataFrame {
    var newDataFrame: DataFrame = [:]
    
    for m in 0...matrix.dimensions.columns - 1 {
      for n in 0...matrix.dimensions.rows - 1 {
        if newDataFrame.data["\(m)"] != nil {
          newDataFrame.data["\(m)"]!.append(matrix.grid[(n * matrix.dimensions.columns) + m])
        } else {
          newDataFrame.data["\(m)"] = [matrix.grid[(n * matrix.dimensions.columns) + m]]
        }
      }
      newDataFrame.columns.append(Column(title: "\(m)", dataType: Double.self))
    }
    newDataFrame.totalRows = matrix.dimensions.rows
    
    return newDataFrame
  }
  
  
  
  
}