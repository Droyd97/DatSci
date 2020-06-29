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

internal typealias MatrixDimension = (rows: Int, columns: Int)


/// Create a 2D Matrix
public struct Matrix: CustomStringConvertible, ExpressibleByArrayLiteral {
    
  var dimensions: MatrixDimension
  var grid: [Double]

  public init(arrayLiteral: [Double]...)   {
    let array: [Double] = arrayLiteral.flatMap{$0}
    self.dimensions.rows = arrayLiteral.count
    self.dimensions.columns = arrayLiteral[0].count
    self.grid = array
    for i in 0...dimensions.rows - 1{
      if arrayLiteral[i].count != dimensions.columns {
        fatalError("Incorrect Marix Dimensions")
      }
    }  
  }

  public var description: String {
    var matrixString: String = ""
    let max = String(grid.max()!).count
    for i in 0...dimensions.rows-1{
      for ii in 0...dimensions.columns-1{
        matrixString += "\(grid[(i * dimensions.columns) + ii])".padding(toLength: max + 5, withPad: " ", startingAt:0)        
      }
      matrixString += "\n"
    }
    return matrixString
  }

  subscript(row: Int, col: Int) -> Double {
    get {
      return grid[(row * dimensions.columns) + col]
    }
    set {
      grid[(row * dimensions.columns)+col] = newValue
    }
  }

  subscript(rowRange: ClosedRange<Int>, columnRange: ClosedRange<Int>) -> Matrix {
    get {
      let rows: Int = rowRange.count
      var newArray: [Double] = []
      for row in rowRange{
        for column in columnRange{
          newArray.append(grid[(row * self.dimensions.columns) + column ])
        }
      }
      let newMatrix = Matrix.array1DToMat(newArray, rows:rows)
      return newMatrix
    }
  }
}



