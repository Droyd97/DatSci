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

class dFMethodTests: XCTestCase {
  var sut: datSci!

  override func setUpWithError() throws {
    super.setUp()
    sut = datSci()
  }

  override func tearDownWithError() throws {
    super.tearDown()
    sut = nil
  }

  func testInsert() throws {
    //Given
    var actualDataFrame: DataFrame = ["name" : ["James" , "Oliver" , "Simon"],
                                      "age" : [19 , 25, 56] ,
                                      "yearUpdate" : [2019 , 2019 , 2020]]
    let expectedDataFrame1: DataFrame = ["name" : ["James" , "Oliver" , "Simon", "Liam"] ,
                                      "age" : [19 , 25, 56, 40] ,
                                      "yearUpdate" : [2019 , 2019 , 2020, 2018]]
    let expectedDataFrame2: DataFrame = ["name" : ["James" , "Oliver" , "Bob", "Simon", "Liam"],
                                         "age" : [19 , 25, 24 , 56, 40],
                                         "yearUpdate" : [2019 , 2019 , 2015 , 2020, 2018]]

    //When
    actualDataFrame.insert(["Liam",40,2018])
    //Then
    XCTAssertTrue(expectedDataFrame1 == actualDataFrame)
    
    //When
    actualDataFrame.insert(["Bob", 24 , 2015])
    //Then
    XCTAssertTrue(expectedDataFrame2 == actualDataFrame)
  }
  
  func testAddColumn() throws {
    //Given
    var actualDataFrame: DataFrame = ["name" : ["James" , "Oliver" , "Simon"] ,
                                      "age" : [19 , 25, 56] ,
                                      "yearUpdate" : [2019 , 2019 , 2020]]
    let expectedDataFrame: DataFrame = ["name" : ["James" , "Oliver" , "Simon"] ,
                                        "age" : [19 , 25, 56] ,
                                        "nationality" : ["British","American","British"],
                                        "yearUpdate" : [2019 , 2019 , 2020]]
    //When
    actualDataFrame.addColumn(title: "nationality",
                              value: ["British","American","British"],
                              position: 2)
    
    //Then
    XCTAssertTrue(expectedDataFrame == actualDataFrame)
  }
  
  func testDelete() throws {
    //Given
    var actualDataFrame: DataFrame = ["name" : ["James" , "Oliver" , "Simon"] ,
                                        "age" : [19 , 25, 56] ,
                                        "nationality" : ["British","American","British"],
                                        "yearUpdate" : [2019 , 2019 , 2020]]
    let expectedDataFrame1: DataFrame = ["name" : ["James" , "Simon"] ,
                                         "age" : [19 , 56] ,
                                         "nationality" : ["British" , "British"],
                                         "yearUpdate" : [2019 , 2020]]
    let expectedDataFrame2: DataFrame = ["name" : ["James" ] ,
                                         "age" : [19 ] ,
                                         "nationality" : ["British"],
                                         "yearUpdate" : [2019]]
    //When
    actualDataFrame.delete(row: 1)
    //Then
    XCTAssertTrue(expectedDataFrame1 == actualDataFrame)
    
    //When
    actualDataFrame.delete()
    //Then
    XCTAssertTrue(expectedDataFrame2 == actualDataFrame)
  }
  
  //  func testIsUnique() throws {
  //    //Given
  //    let testDataFrame: DataFrame = ["name" : ["James" , "Oliver" , "Simon"] ,
  //                                      "age" : [19 , 25, 56] ,
  //                                      "yearUpdate" : [2019 , 2019 , 2020]]
  //    let expectedUniqueArrays = ["name","age","yearUpdate"]
  //    //When
  //    let ActualUniqueArrays = testDataFrame.isUnique()
  //    //Then
  //    XCTAssertTrue(expectedUniqueArrays == ActualUniqueArrays)
  //  }

  func testPerformanceExample() throws {
        // This is an example of a performance test case.
    self.measure {
            // Put the code you want to measure the time of here.
    }
  }
}
