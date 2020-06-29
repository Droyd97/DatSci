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

public extension Matrix {
  
  /// <#Description#>
  /// - Parameters:
  ///   - left: <#left description#>
  ///   - right: <#right description#>
  /// - Returns: <#description#>
  static func * (left: Matrix, right: Matrix) -> Matrix {
  try! enforceMultDimensions(left: left.dimensions, right: right.dimensions)
  let n = left.dimensions.rows
  let m = left.dimensions.columns
  let p = right.dimensions.columns
  var C: [Double] = [Double](repeating: 0.0, count: n * p)
  for i in 0...n - 1 {
    for j in 0...p - 1 {
      var sum: Double = 0
      for k in 0...m - 1{
        print(right.grid[(k * right.dimensions.columns) + j])
        sum += left.grid[(i * left.dimensions.columns) + k] * right.grid[(k * right.dimensions.columns) + j]
      }
      C[(i * p) + j] = sum
    }        
  }
  print(C)
    let newMatrix = Matrix.array1DToMat(C, rows: p)
  return newMatrix
  }
    
  
  /// <#Description#>
  /// - Parameters:
  ///   - left: <#left description#>
  ///   - right: <#right description#>
  /// - Returns: <#description#>
  static func .* (left: Matrix, right: Matrix) -> Matrix {
    try! enforceAddDimensions(got: left.dimensions, expected: right.dimensions)
    let n = right.grid.count
    var C: [Double] = [Double](repeating: 0.0, count: n)
    for i in 0...n - 1 {
      C[i] = left.grid[i] * right.grid[i]
    }
    let newMatrix = Matrix.array1DToMat(C, rows: left.dimensions.rows)
    return newMatrix
  }
    
  /// <#Description#>
  /// - Parameters:
  ///   - matrix: <#matrix description#>
  ///   - power: <#power description#>
  /// - Returns: <#description#>
  static func .^^ (matrix: Matrix, power: Double) -> Matrix {
    let n = matrix.grid.count
    var C: [Double] = [Double](repeating: 0.0, count: n)
    for i in 0...n - 1 {
      C[i] = matrix.grid[i] ^^ power
    }
    let newMatrix = Matrix.array1DToMat(C, rows: matrix.dimensions.rows)
    return newMatrix
  }
  
  
  static func .^^ (matrix: Matrix, power: Int) -> Matrix {
    let n = matrix.grid.count
    var C: [Double] = [Double](repeating: 0.0, count: n)
    for i in 0...n - 1 {
      C[i] = matrix.grid[i] ^^ power
    }
    let newMatrix = Matrix.array1DToMat(C, rows: matrix.dimensions.rows)
    return newMatrix
  }
  
  /// <#Description#>
  /// - Parameters:
  ///   - matrix: <#matrix description#>
  ///   - denominator: <#denominator description#>
  /// - Returns: <#description#>
  static func ./ (matrix: Matrix, denominator: Double) -> Matrix {
    let n = matrix.grid.count
    var C: [Double] = [Double](repeating: 0.0, count: n)
    for i in 0...n - 1 {
      C[i] = matrix.grid[i] / denominator
    }
    let newMatrix = Matrix.array1DToMat(C, rows: matrix.dimensions.rows)
    return newMatrix
  }
  
  /// <#Description#>
  /// - Parameters:
  ///   - left: <#left description#>
  ///   - right: <#right description#>
  /// - Returns: <#description#>
  static func + (left: Matrix, right: Matrix) -> Matrix {
    try! enforceAddDimensions(got: left.dimensions, expected: right.dimensions)
    let n = right.grid.count
    var C: [Double] = [Double](repeating: 0.0, count: n)
    for i in 0...n - 1 {
      C[i] = left.grid[i] + right.grid[i]
    }
    let newMatrix = Matrix.array1DToMat(C, rows: left.dimensions.rows)
    return newMatrix
  }
  
  /// <#Description#>
  /// - Parameters:
  ///   - left: <#left description#>
  ///   - right: <#right description#>
  /// - Returns: <#description#>
  static func - (left: Matrix, right: Matrix) -> Matrix {
    try! enforceSubtractDimensions(got: left.dimensions, expected: right.dimensions)
    let n = right.grid.count
    var C: [Double] = [Double](repeating: 0.0, count: n)
    for i in 0...n - 1 {
      C[i] = left.grid[i] - right.grid[i]
    }
    let newMatrix = Matrix.array1DToMat(C, rows: left.dimensions.rows)
    return newMatrix
  }
  
  
  
  
  
}

