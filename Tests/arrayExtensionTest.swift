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

class arrayExtensionTest: XCTestCase {

  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }
  
  func testArrayUnique() throws {
    //Given
    let testArray1 = [6,7,6,7,8]
    let testArray2 = [1,3,5,7]
    //When
    let test = testArray1.unique()
    let test2 = testArray2.unique()
    //Then
    XCTAssertFalse(test)
    XCTAssertTrue(test2)
    
  }
  
  func testArrayAnyType() throws {
    //Given
    let testArray: [Any] = ["British","American","British"]
    //When
    print(testArray.typeAny)
    //Then
  }
  
  func testArrayEquatable() throws {
    //Given
    let actual: [Any] = ["James", 6 , "Ryan"]
    let expected: [Any] = ["James", 6 , "Ryan"]
    //When
    let equated: Bool = actual == expected
    //Then
    XCTAssertTrue(equated)
  }

  func testPerformanceExample() throws {
      // This is an example of a performance test case.
      // self.measure {
          
      //}
  }

}
