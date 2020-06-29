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

public extension Matrix{
  
  /// <#Description#>
  /// - Parameters:
  ///   - array: <#array description#>
  ///   - rows: <#rows description#>
  /// - Returns: <#description#>
  static func array1DToMat(_ array: [Double], rows: Int) -> Matrix{
    var newMatrix: Matrix = [[0]]
    newMatrix.grid = array
    newMatrix.dimensions.rows = rows
    newMatrix.dimensions.columns = array.count / rows
    if (newMatrix.dimensions.rows * newMatrix.dimensions.columns) != newMatrix.grid.count{
      fatalError("Incorrect Matrix Dimensions")
    }
    return newMatrix
  }
  
  /// <#Description#>
  /// - Parameter array: <#array description#>
  /// - Returns: <#description#>
  static func arrayToMat(_ array: [[Double]]) -> Matrix{
    var newMatrix: Matrix = [[0]]
    newMatrix.grid = array.flatMap{$0}
    newMatrix.dimensions.rows = array.count
    newMatrix.dimensions.columns = array[0].count
    for i in 0...newMatrix.dimensions.rows-1{
      if array[i].count != newMatrix.dimensions.columns{
        fatalError("Incorrect Matrix Dimensions")
      }
    }
    return newMatrix
  }
}
