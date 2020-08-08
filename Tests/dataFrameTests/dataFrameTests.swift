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

class dataFrameTests: XCTestCase {

  

  override func setUpWithError() throws {
    super.setUp()

      
  }

  override func tearDownWithError() throws {
    super.tearDown()

  }
  
  func testSubscriptColumn() throws {
    //Given
    var testDataFrame: DataFrame = ["name" : ["James" , "Oliver" , "Simon"],
    "age" : ["19" , "25", "56"] ,
    "yearUpdate" : [2019 , 2019 , 2020]]
    let expectedColumn: [String] = ["James","Oliver","Simon"]
    //When
    testDataFrame.asType(column: "age", type: Int.self)
    let actualColumn: [Int] = testDataFrame["age"]
    print(actualColumn)
    //Then
    //XCTAssert(expectedColumn == actualColumn)
  }
  
  // TODO: Complete
  func testSubscriptCell() throws {
    //Given
    let testDataFrame: DataFrame = ["name" : ["James" , "Oliver" , "Simon"],
    "age" : [19 , 25, 56] ,
    "yearUpdate" : [2019 , 2019 , 2020]]
    //When
        let actualColumn: Any = testDataFrame[2,2]
    //Then
    
  }

  func testSubscriptRange() throws {
    //Given
    let testDataFrame: DataFrame = ["name" : ["James" , "Oliver" , "Simon"],
                                      "age" : [19 , 25, 56] ,
                                      "yearUpdate" : [2019 , 2019 , 2020]]
    let expectedDataFrame: DataFrame = ["age": [25,56], "yearUpdate" : [2019,2020]]
    //When
    let actualDataFrame = testDataFrame[1...2,2...3]
    //Then
    XCTAssertTrue(expectedDataFrame == actualDataFrame)
  }
  
  func testPerformanceExample() throws {
      // This is an example of a performance test case.
    // self.measure {
      // Put the code you want to measure the time of here.
  }
}

