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

import XCTest
@testable import DatSci
import class Foundation.Bundle
import SwiftKuery
import SwiftKueryPostgreSQL

class dFConversionTests: XCTestCase {
  
  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  func testJsonToDataFrame() throws {
    //Given
    let jsonData = jsonString.data(using: .utf8)!
    let testPath = \TestDataStruct.data
    let expected: DataFrame = ["name" : ["James" , "Oliver" , "Simon"] ,
                               "age" : [19 , 25, 56] ,
                               "nationality" : ["British","American","British"],
                               "yearUpdate" : [2019 , 2019 , 2020]]
    
    //When
    let actual = DataFrame.jsonToDataFrame(data: jsonData,
                                          model: TestDataStruct.self,
                                          path: testPath)
    //Then
    XCTAssertTrue(expected == actual)
  }
  
  func testCSVToDataFrame() throws {
    //Given
    let bundle = Bundle(for: type(of: self))
    let path = bundle.url(forResource: "UNdata_Export_CSVTest", withExtension: "csv")!
    let expectedDataFrame: DataFrame = ["Year": ["2018","2018"],"Area": ["Total","Total"],"Sex": ["Male","Female"],"City": ["MARIEHAMN","MARIEHAMN"],"City type": ["City proper","City proper"],"Record Type": ["Estimate - de jure","Estimate - de jure"],"Reliability": ["Final figure, complete","Final figure, complete"]]
    //When
    let actualDataFrame = DataFrame.csvToDataFrame(path)
    //Then
    XCTAssertTrue(actualDataFrame[1...2,1...7] == expectedDataFrame)
    
  }
  
  func testDataFrameToSQL() throws {
    let bundle = Bundle(for: type(of: self))
    let path = bundle.url(forResource: "PostgreSQLCredentials", withExtension: "json")!
    let jsonData = (try! String(contentsOf: path).data(using: .utf8))!
    let decodeData = try! JSONDecoder().decode(PostgreSQLCredentials.self, from: jsonData)
    
    let dataFrame: DataFrame = ["Year": ["2018","2018"],"Area": ["Total","Total"],"Sex": ["Male","Female"],"City": ["MARIEHAMN","MARIEHAMN"],"City type": ["City proper","City proper"],"Record Type": ["Estimate - de jure","Estimate - de jure"],"Reliability": ["Final figure, complete","Final figure, complete"]]
    DataFrame.dataFrameToSQL(dataFrame, tableName: "test", options: [.databaseName(decodeData.databaseName), .userName(decodeData.userName), .password(decodeData.password)])
  }
  
  func testCheckTable() throws {
    let bundle = Bundle(for: type(of: self))
    let path = bundle.url(forResource: "PostgreSQLCredentials", withExtension: "json")!
    let jsonData = (try! String(contentsOf: path).data(using: .utf8))!
    let decodeData = try! JSONDecoder().decode(PostgreSQLCredentials.self, from: jsonData)
    
    let pool = PostgreSQLConnection.createPool(host: decodeData.host, port: decodeData.port, options: [.databaseName(decodeData.databaseName), .userName(decodeData.userName), .password(decodeData.password)], poolOptions: ConnectionPoolOptions(initialCapacity: 1, maxCapacity: 1))
    
    SQLORM.checkTable(pool,table: "temptable") { result in
      switch result {
      case .success(let exists):
        print(exists)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func testRawQueryOutput() throws {
    let bundle = Bundle(for: type(of: self))
    let path = bundle.url(forResource: "PostgreSQLCredentials", withExtension: "json")!
    let jsonData = (try! String(contentsOf: path).data(using: .utf8))!
    let decodeData = try! JSONDecoder().decode(PostgreSQLCredentials.self, from: jsonData)
    
    let pool = PostgreSQLConnection.createPool(host: decodeData.host, port: decodeData.port, options: [.databaseName(decodeData.databaseName), .userName(decodeData.userName), .password(decodeData.password)], poolOptions: ConnectionPoolOptions(initialCapacity: 1, maxCapacity: 1))
    
    SQLORM.rawQueryOutput(pool, query: "SELECT * FROM option_chains") { result in
      switch result {
      case .success(let value):
        print(value)
      case .failure(let error):
        print(error)
      }
    }
  }
  
  func testDatToDF() throws {
    //Given
    let matrix: Matrix = [[5,4,3],[2,6,7],[5,8,9]]
    //When
    let actualDataFrame = DataFrame.matToDF(matrix)
    //Then
    print(actualDataFrame)
  }
  
  func testPerformanceCSVToDataFrame() throws {
    let bundle = Bundle(for: type(of: self))
    let path = bundle.url(forResource: "GeographicUnitsPerformanceTests", withExtension: "csv")!
    
    self.measure {
      _ = DataFrame.csvToDataFrame(path)
      }
  }

}

private let jsonString = """

  {
    "date": "2019",
    "data":
    [
        {
          "name":"James",
          "age":19,
          "nationality": "British",
          "yearUpdate":2019
        },
        {
          "name": "Oliver",
          "age": 25,
          "nationality": "American",
          "yearUpdate":2019
        },
        {
          "name": "Simon",
          "age":56,
          "nationality": "British",
          "yearUpdate":2020
        },
    ]
  }
"""
private struct TestDataStruct: Codable{
  let date: String
  let data: [Details]
}
private struct Details: Codable{
  let name: String
  let age: Int
  let nationality: String
  let yearUpdate: Int
}

private struct PostgreSQLCredentials: Codable {
  let host: String
  let port: Int32
  let databaseName: String
  let userName: String
  let password: String
}