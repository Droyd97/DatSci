//
//  ArrayEquatableTest.swift
//  DatSciTests
//
//  Created by Alexander Oldroyd on 17/04/2020.
//
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
