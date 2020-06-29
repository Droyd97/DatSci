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

class matrixOperatorsTests: XCTestCase {
  var sut: datSci!
  
  override func setUpWithError() throws {
    super.setUp()
    sut = datSci()
  }

  override func tearDownWithError() throws {
    super.tearDown()
    sut = nil
  }
  
  func testMultiplication() throws {
    //Given
    let actualMatrix1: Matrix = [[1,3,5],[2,6,7]]
    let actualMatrix2: Matrix = [[3,2],[9,7],[5,6]]
    let expectedMatrix: Matrix = [[55,53],[95,88]]
    //When
    let calculatedMatrix = actualMatrix1 * actualMatrix2
    //Then
    XCTAssertTrue(calculatedMatrix.grid == expectedMatrix.grid)
  }
  
  func testElementMultiplication() throws {
    //Given
    let actualMatrix1: Matrix = [[3,5],[7,2],[9,5]]
    let actualMatrix2: Matrix = [[4,3],[6,2],[1,5]]
    let expectedMatrix: Matrix = [[12,15],[42,4],[9,25]]
    //When
    let calculatedMatrix = actualMatrix1 .* actualMatrix2
    //Then
    XCTAssertTrue(calculatedMatrix.grid == expectedMatrix.grid)
  }
  
  func testElementDivide() throws {
    //Given
    let actualMatrix: Matrix = [[3,5],[-7,2],[9,5]]
    let denominator: Double = 3
    let expectedMatrix: Matrix = [[1, 5/3], [-7/3, 2/3], [3, 5/3]]
    //When
    let calculatedMatrix = actualMatrix ./ denominator
    //Then
    XCTAssertTrue(calculatedMatrix.grid == expectedMatrix.grid)
  }
  
  func testElementPower() throws {
    //Given
    let actualMatrix1: Matrix = [[3,5],[-7,2],[9,5]]
    let actualMatrix2: Matrix = [[1,3],[2,-5]]
    let power1 = 2
    let power2 = 3
    let power3 = 3.5
    let expectedMatrix1: Matrix = [[9,25],[49,4],[81,25]]
    let expectedMatrix2: Matrix = [[27,125],[-343,8],[729,125]]
    let expectedMatrix3: Matrix = [[1,46.76537180435969],[11.313708498984761,-279.5084971874737]]
    //When
    let calculatedMatrix1 = actualMatrix1 .^^ power1
    let calculatedMatrix2 = actualMatrix1 .^^ power2
    let calculatedMatrix3 = actualMatrix2 .^^ power3
    //Then
    XCTAssertTrue(calculatedMatrix1.grid == expectedMatrix1.grid)
    XCTAssertTrue(calculatedMatrix2.grid == expectedMatrix2.grid)
    print(calculatedMatrix3)
    XCTAssertTrue(calculatedMatrix3.grid == expectedMatrix3.grid)
  }
  
  func testAddition() throws {
    //Given
    let actualMatrix1: Matrix = [[3,5],[7,2],[9,5]]
    let actualMatrix2: Matrix = [[4,3],[6,2],[1,5]]
    let expectedMatrix: Matrix = [[7,8],[13,4],[10,10]]
    //When
    let calculatedMatrix = actualMatrix1 + actualMatrix2
    //Then
    XCTAssertTrue(calculatedMatrix.grid == expectedMatrix.grid)
  }
  
  func testSubtraction() throws {
    //Given
    let actualMatrix1: Matrix = [[3,5],[7,2],[9,5]]
    let actualMatrix2: Matrix = [[4,3],[6,2],[1,5]]
    let expectedMatrix: Matrix = [[-1, 2], [1,0], [8,0]]
    //When
    let calculatedMatrix = actualMatrix1 - actualMatrix2
    //Then
    XCTAssertTrue(calculatedMatrix.grid == expectedMatrix.grid)
  }
  
//  func testDotProduct() throws {
//    //Given
//    let actualMatrix1: Matrix = [[3,5],[7,2],[9,5]]
//    let actualMatrix2: Matrix = [[4,3],[6,2],[1,5]]
//    let expectedValue: [Double] =
//    //When
//    //Then
//  }

  func testPerformanceExample() throws {
        // This is an example of a performance test case.
    self.measure {
            // Put the code you want to measure the time of here.
    }
  }
}
