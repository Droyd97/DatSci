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

public extension DataFrame {
  
  /// The 'QueryBuilder' class is used for forming the raw string queries for creating and inserting data from a DataFrame into an SQL table.
  class QueryBuilder {
    
    var stringQuery: String = ""
    var dataFrame: DataFrame
    var columns: [(String,sqlDataTypes, Int?)] = []
    
    init(_ dataFrame: DataFrame) {
      self.dataFrame = dataFrame
    }
    
    func createTable(_ tableName: String) {
      stringQuery = ""
    
      var columnQuery: String = " ("
      
      for i in 0...dataFrame.columns.count - 1 {
        switch dataFrame.columns[i].dataType {
        case _ as String.Type:
          columns += [(dataFrame.columns[i].title.replacingOccurrences(of: " ", with: "" ),.varChar, 256)]
        case _ as Int.Type:
          columns += [(dataFrame.columns[i].title.replacingOccurrences(of: " ", with: "" ),.int, nil)]
        case _ as Double.Type:
          columns += [(dataFrame.columns[i].title.replacingOccurrences(of: " ", with: "" ),.double, nil)]
        case _ as Bool.Type:
          columns += [(dataFrame.columns[i].title.replacingOccurrences(of: " ", with: "" ),.bool, nil)]
        default:
          columns += [(dataFrame.columns[i].title.replacingOccurrences(of: " ", with: "" ),.text, nil)]
        }
      }
      
      for column in columns.dropLast() {
        if column.2 != nil {
          columnQuery += " \(column.0) " + column.1.rawValue + "(\(column.2!))" + ","
        } else {
          columnQuery += " \(column.0) " + column.1.rawValue + ","
        }
      }
      if columns.last!.2 != nil {
        columnQuery += " \(columns.last!.0) " + columns.last!.1.rawValue + "(\(columns.last!.2!))" + ")"
      } else {
        columnQuery += " \(columns.last!.0) " + columns.last!.1.rawValue + ")"
      }
      
      stringQuery += "CREATE TABLE " + tableName + columnQuery + ";"
      
      
    }
    
    func insertData(_ tableName: String) {
      stringQuery = ""
      var columnList: String = ""
      
      for column in dataFrame.columns.dropLast() {
        columnList += column.title.replacingOccurrences(of: " ", with: "" ) + ","
      }
      columnList += dataFrame.columns.last!.title.replacingOccurrences(of: " ", with: "" )
      
      var rowQuery: String = "INSERT INTO " + tableName + " (\(columnList)) " + "VALUES "
      //let columnType = dataFrame.columns[dataFrame.columns.firstIndex(where: ({$0.title == column}))!].dataType
      
      
      
      for i in 0...dataFrame.totalRows - 1 {
        
        var rowList: String = "("
        for column in dataFrame.columns.dropLast() {
          
          let value = dataFrame.data[column.title]![i]
            switch value {
            case _ as String:
              rowList += "'\(String(value as! String))'" + ","
            case _ as Int:
              rowList += String(value as! Int) + ","
            case _ as Double:
              rowList += String(value as! Double) + ","
            case _ as Bool:
              rowList += String(value as! Bool) + ","
            default:
              assertionFailure("Cannot Convert")
            }
        }
        let value = dataFrame.data[dataFrame.columns.last!.title]![i]
          switch value {
          case _ as String:
            rowList += "'\(String(value as! String))'" + ")"
          case _ as Int:
            rowList += String(value as! Int) + ")"
          case _ as Double:
            rowList += String(value as! Double) + ")"
          case _ as Bool:
            rowList += String(value as! Bool) + ")"
          default:
            assertionFailure("Cannot Convert")
            }
          
          if i != dataFrame.totalRows - 1 {
            rowQuery += rowList + ","
          } else {
            rowQuery += rowList
          }
        
    
      }
      stringQuery += rowQuery + ";"

    }
    
    
      


  public enum sqlDataTypes: String {
    
    public typealias RawValue = String
    
  //  case char
    case varChar = "VARCHAR"
  //  case binary
  //  case varBinary
  //  case tinyBlob
  //  case tinyText
    case text = "TEXT"
  //  case blob
  //  case mediumtext
  //  case mediumBlob
  //  case longText
  //  case longBlob
  //  case Enum
  //  case set
  //
  //  case bit
  //  case tinyInt
    case bool = "BOOL"
  //  case boolean
  //  case smallInt
  //  case mediumInt
    case int = "INT"
  //  case integer
  //  case bigint
  //  case float
    case double = "DOUBLE"
  //  case doublePrecision = "DOUBLE"
  //  case decimal
  //  case dec
  //
  //  case date
  //  case dateTime
  //  case timeStamp
  //  case time
  //  case year

    }
  }
}
