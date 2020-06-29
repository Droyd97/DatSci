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


/**
 This 'SQLORM' class is an ORM built upon IBM's Swift Kuery to allow easy implementation of SQL raw queries.
 */
final public class SQLORM{
  
  // Typealias for the completion handler that retruns a boolean result.
  typealias HandlerBool = (Result<Bool,Error>) -> Void
  // Typealias for the completion handler that returns an array of Any result.
  typealias Handler = (Result<[Any],Error>) -> Void
  
  
  /// Check to see whether the table exists in a PostgreSQL database
  /// - Parameters:
  ///   - connection: A Connection Pool.
  ///   - table: The title of the table to check.
  ///   - completionHandler: A closure that returns a boolean result if it exists
  static func checkTable(_ connection: ConnectionPool, table: String, completionHandler: @escaping HandlerBool )  {
    var exists = false
    let waitSemaphore = DispatchSemaphore(value: 0)

    connection.getConnection() { connection, error in
        guard let connection = connection else {
            print("Error connecting to Database")
            return
        }

      connection.execute("SELECT to_regclass('public.\(table)');") { queryResult in
        guard let resultSet = queryResult.asResultSet else {
          print("Error executing raw query")
            return
        }
        resultSet.forEach(){row, error in
          guard let rows = row else {
            waitSemaphore.signal()
            return
          }
          guard rows[0] != nil else {
            return exists = false
          }
          exists = true
        }
      }
    }
    waitSemaphore.wait()
    completionHandler(.success(exists))
  }
  
  

  static func rawQuery(_ conection: ConnectionPool, query: String) {
    let pool = conection
    let waitSemaphore = DispatchSemaphore(value: 0)
    
    pool.getConnection() { connection, error in
        guard let connection = connection else {
            print("Error connecting to Database")
            return
        }
      connection.execute(query) { queryResult in
        switch queryResult {
        case .error(let error):
          print(error)
        case .resultSet(_):
          fallthrough
        case .success(_):
          fallthrough
        case .successNoData:
          fallthrough
        default:
          return
        }
      }
      waitSemaphore.signal()
    }
    waitSemaphore.wait()
  }
  
  static func rawQueryOutput(_ conection: ConnectionPool, query: String, completionHandler: @escaping Handler) {
    let pool = conection
    var output: [Any] = []
    let waitSemaphore = DispatchSemaphore(value: 0)

    pool.getConnection() { connection, error in
      guard let connection = connection else {
        print("Error connecting to Database")
        return
        }
      connection.execute(query) { queryResult in
        guard let resultSet = queryResult.asResultSet else {
          print("Error executing raw query")
            return
          }
        resultSet.forEach(){row, error in
          guard let rows = row else {
            waitSemaphore.signal()
            return
          }
          output.append(rows)
        }
      }
    }
    waitSemaphore.wait()
    completionHandler(.success(output))
  }
}
