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

import XCTest
@testable import DatSci
import class Foundation.Bundle

class HelperFuncTests: XCTestCase {

  

  override func setUpWithError() throws {
    super.setUp()

      
  }

  override func tearDownWithError() throws {
    super.tearDown()

  }
  
  //TODO: Complete
  func testTypeConverter() throws {
    //Given
    let dataDouble: [Any] = [5.0,4.0,3.0]
    let dataString: [Any] = ["James", "Oliver", "Simon"]
    let dataIntString: [String] = ["56","46","34"]
    let dataInt: [Any] = [5,4,3]
    let dataBool: [Any] = [true, false, false]
    
    let expectedDataDouble: [Double] = [5.0,4.0,3.0]
    let expectedDataString: [String] = ["James","Oliver","Simon"]
    let expectedDataInt: [Int] = [5,4,3]
    let expectedDataBool: [Bool] = [true, false, false]
    //When
    let actualDataDouble: [Double] = dataDouble.map({typeConverter($0, convertTo: Double.self)!})
    let actualDataString: [String] = dataString.map({typeConverter($0, convertTo: String.self)!})
    let actualDataInt: [Int] = dataInt.map({typeConverter($0, convertTo: Int.self)!})
    let actualDataBool: [Bool] = dataBool.map({typeConverter($0, convertTo: Bool.self)!})
    let stringToInt: [Int] = dataIntString.map({typeConverter($0, convertTo: Int.self)!})
    print(stringToInt)
    //Then
    XCTAssert(actualDataDouble == expectedDataDouble)
    XCTAssert(actualDataString == expectedDataString)
    XCTAssert(actualDataInt == expectedDataInt)
    XCTAssert(actualDataBool == expectedDataBool)
  }
  
  func testPerformanceExample() throws {
      // This is an example of a performance test case.
    // self.measure {
      // Put the code you want to measure the time of here.
  }
}

