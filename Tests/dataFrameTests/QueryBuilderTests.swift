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

class QueryBuilderTests: XCTestCase {

  override func setUpWithError() throws {
    super.setUp()
  }

  override func tearDownWithError() throws {
    super.tearDown()
  }

  func testInsertData() throws {
    //Given
      let dataFrame: DataFrame = ["name": ["James","Ryan","Oliver"], "age": [12,6,5], "gpa": [3.0,4.2,4.5], "graduated": [false, false, true]]
    //When
    let query = DataFrame.QueryBuilder(dataFrame)
    query.insertData("test")
    print(query.stringQuery)
    //Then
    
  }
  
  func testPerformanceExample() throws {
      // This is an example of a performance test case.
      self.measure {
          // Put the code you want to measure the time of here.
      }
  }

}
