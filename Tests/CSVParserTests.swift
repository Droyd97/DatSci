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
import Foundation

class CSVParserTests: XCTestCase {
  //var sut: CSVParser!
  
  override func setUpWithError() throws {
    super.setUp()
    //sut = CSVParser()

  }
  
  
  func testRead() throws {
    let bundle = Bundle(for: type(of: self))
    let path = bundle.url(forResource: "UNdata_Export_CSVTest", withExtension: "csv")!
    let inputStream = InputStream(url: path)!
    let reader = ByteReader(inputStream)
    _ = reader.read(len: 100)
    XCTAssertTrue(String(Unicode.Scalar(reader.buffer[1])) == "C" )
    
  }
  
  func testParse() throws {
    //Given
    let bundle = Bundle(for: type(of: self))
    let path = bundle.url(forResource: "UNdata_Export_CSVTest", withExtension: "csv")!
    let inputStream = InputStream(url: path)!
    var parse = Parser(inputStream)
    let expectedReturn: ArraySlice<String> = ["Åland Islands","2018","Total","Female","MARIEHAMN","City proper","Estimate - de jure","Final figure, complete","2019","6088.5","1"]
    //When
    parse.parse()
    let actualReturn = parse.value[33...43]
    //Then
    XCTAssertTrue(actualReturn == expectedReturn)
  }
  
  func testParseToDict1() throws {
    //Given
    let bundle = Bundle(for: type(of: self))
    let path = bundle.url(forResource: "UNdata_Export_CSVTest", withExtension: "csv")!
    let inputStream = InputStream(url: path)!
    var parse = ParserToDict(inputStream)
    let expectedReturn: ArraySlice<String> = ["11709","5620.5","6088.5","11621","5583"]
    //When
    parse.parse()
    let actualReturn = parse.value["9"]![1...5]
    //Then
    XCTAssertTrue(actualReturn == expectedReturn)
  }

  func testParseToDict2() throws {
    //Given
    let bundle = Bundle(for: type(of: self))
    let path = bundle.url(forResource: "UNdata_Export_CSVTest", withExtension: "csv")!
    let inputStream = InputStream(url: path)!
    var parse = ParserToDict(inputStream, headerFlag: true)
    let expectedReturn: ArraySlice<String> = ["11709","5620.5","6088.5","11621","5583"]
    //When
    parse.parse()
    let actualReturn = parse.value["Value"]![0...4]
    //Then
    XCTAssertTrue(actualReturn == expectedReturn)
  }


  func testPerformanceExample() throws {
        // This is an example of a performance test case.
    self.measure {
            // Put the code you want to measure the time of here.
    }
  }

  override func tearDownWithError() throws {
    super.tearDown()
    //sut = nil
  }
  
  
}

