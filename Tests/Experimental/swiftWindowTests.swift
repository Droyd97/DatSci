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

class swiftWindowTests: XCTestCase {
  var sut: datSci!
  
  override func setUpWithError() throws {
    super.setUp()
    sut = datSci()
    

        // In UI tests it is usually best to stop immediately when a failure occurs.
    continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.

        // In UI tests it’s important to set the initial state required for your tests before they run. The setUp method is a good place to do this.
  }

  override func tearDownWithError() throws {
    super.tearDown()
    sut = nil
  }

  func testGUI() throws {
    //Given
    //When
    GUI()
    //Then
  }

}
