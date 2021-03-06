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

class matrixMethodsTests: XCTestCase {
  var sut: datSci!
  
  override func setUpWithError() throws {
    super.setUp()
    sut = datSci()
  }

  override func tearDownWithError() throws {
    super.tearDown()
    sut = nil
  }

  func testTranspose() throws {
    //Given
    var actualMatrix: Matrix = [[5,4,3],[4,3,1],[9,7,8]]
    let expectedMatrix: Matrix = [[5,4,9],[4,3,7],[3,1,8]]
    //When
    actualMatrix.transpose()
    //Then
    print(actualMatrix)
    XCTAssertTrue(actualMatrix.grid == expectedMatrix.grid)
  }

  func testPerformanceExample() throws {
        // This is an example of a performance test case.
    self.measure {
            // Put the code you want to measure the time of here.
    }
  }
}
