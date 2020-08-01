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

  func testJsonToDataFrameCase1() throws {
    let bundle = Bundle(for: type(of: self))
    let path = bundle.url(forResource: "jsonConverterTestFile", withExtension: "json")!
    let testPath = \TestDataStruct.data
    let expected: DataFrame = ["name" : ["James" , "Oliver" , "Simon"] ,
                               "age" : [19 , 25, 56] ,
                               "nationality" : ["British","American","British"],
                               "yearUpdate" : [2019 , 2019 , 2020]]

    //When
    let actual: DataFrame = DataFrame.jsonToDataFrame(path,
                                                      pathType: .file,
                                                      model: TestDataStruct.self,
                                                      keypath: testPath)
    //Then
    XCTAssertTrue(expected == actual)
  }
  
//  func testConverter() throws {
//    let waitSemaphore = DispatchSemaphore(value: 0)
//    URLSession.shared.dataTask(with: URL(string: "https://finnhub.io/api/v1/stock/symbol?exchange=US&token=bpi12g7rh5rbgl0l7kcg")!) { data, response, error in
//      if let datas = data {
//        do {
//          let decoder = JSONDecoder()
//          let json = try decoder.decode([Symbols].self, from: datas)
//          print(json)
//          waitSemaphore.signal()
//        } catch {
//          print("Error")
//          waitSemaphore.signal()
//        }
//      } else {
//        print("No data")
//        waitSemaphore.signal()
//      }
//    }.resume()
//    waitSemaphore.wait()
//  }
  
  func testJsonToDataFrameCase2() throws {
    //Given
    let jsonData = jsonString.data(using: .utf8)!
    let testPath = \TestDataStruct.data
    let expected: DataFrame = ["currency" : ["USD" , "USD" , "USD"] ,
                               "description" : ["AGILENT TECHNOLOGIES INC" , "ALCOA CORP", "PERTH MINT PHYSICAL GOLD ETF"] ,
                               "displaySymbol" : ["A","AA","AAAU"],
                               "symbol" : ["A" , "AA" , "AAAU"], "type":["EQS","EQS","ETF"]]
    
    //When
    let actual: DataFrame = DataFrame.jsonToDataFrame(URL(string: "https://finnhub.io/api/v1/stock/symbol?exchange=US&token=bpi12g7rh5rbgl0l7kcg")!, pathType: .url, model: [Symbols].self, keypath: \[Symbols].self)
    //Then
    XCTAssertTrue(expected == actual[0...2,0...5])
  }
  
  func testJsonToDataFrameCase3() throws {
    let testPath = \DailyData.data
    let expected: DataFrame = ["name" : ["James" , "Oliver" , "Simon"] ,
                               "age" : [19 , 25, 56] ,
                               "nationality" : ["British","American","British"],
                               "yearUpdate" : [2019 , 2019 , 2020]]

    //When
    var actual: DataFrame = DataFrame.jsonToDataFrame(URL(string: "https://www.alphavantage.co/query?function=TIME_SERIES_DAILY&symbol=IBM&outputsize=compact&apikey=U6UPZQI990E8HPDX")!,
                                                      pathType: .url,
                                                      model: DailyData.self, keypath: testPath, nesting: .dictionary)
    //Then
    actual.sortValues(by: "key")
    print(actual)
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
  
  //TODO: Finish up Test
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
  
  func testMatToDF() throws {
    //Given
    let matrix: Matrix = [[5,4,3],[2,6,7],[5,8,9]]
    let expectedDataFrame: DataFrame = ["0": [5.0,2.0,5.0], "1": [4.0,6.0,8.0], "2": [3.0,7.0,9.0]]
    //When
    let actualDataFrame = DataFrame.matToDF(matrix)
    //Then
    XCTAssert(actualDataFrame == expectedDataFrame)
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



private struct Finnhub: Codable {
  let data: [Symbols]
}

private struct Symbols: Codable {
  let currency: String
  let description: String
  let displaySymbol: String
  let symbol: String
  let type: String
}

private struct PostgreSQLCredentials: Codable {
  let host: String
  let port: Int32
  let databaseName: String
  let userName: String
  let password: String
}

struct DailyData: Codable {
  let metadata: InfoStruct
  let data: [String: candleData]
  
  
  
  enum CodingKeys: String, CodingKey {
    case metadata = "Meta Data"
    case data = "Time Series (Daily)"
    
    
  }
}

struct InfoStruct: Codable {
  let information: String
  let symbol: String
  let refresh: String
  let outputSize: String
  let timeZone: String
  
  enum CodingKeys: String, CodingKey {
    case information = "1. Information"
    case symbol = "2. Symbol"
    case refresh = "3. Last Refreshed"
    case outputSize = "4. Output Size"
    case timeZone = "5. Time Zone"
  }
}

struct candleData: Codable {
  let open: String
  let high: String
  let low: String
  let close: String
  let volume: String
  
  enum CodingKeys: String, CodingKey {
    case open = "1. open"
    case high = "2. high"
    case low = "3. low"
    case close =  "4. close"
    case volume =  "5. volume"
  }
}


